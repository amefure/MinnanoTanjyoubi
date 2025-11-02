//
//  AppLockViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import Combine
import LocalAuthentication
import UIKit

@Observable
final class AppLockState {
    /// アプリメイン画面遷移
    var isShowApp: Bool = false
    /// パスワード失敗アラート
    var isShowFailureAlert: Bool = false
    /// プログレス表示
    fileprivate(set) var isShowProgress: Bool = false
    fileprivate(set) var type: LABiometryType = .none
    private(set) var isLogin: Bool = false
}

final class AppLockViewModel {
    var state = AppLockState()

    private var cancellables: Set<AnyCancellable> = []

    /// `Repository`
    private let repository: RealmRepository
    private let biometricAuthRepository: BiometricAuthRepository
    private let keyChainRepository: KeyChainRepository

    init(
        repository: RealmRepository,
        keyChainRepository: KeyChainRepository,
        biometricAuthRepository: BiometricAuthRepository
    ) {
        self.repository = repository
        self.biometricAuthRepository = biometricAuthRepository
        self.keyChainRepository = keyChainRepository
    }

    @MainActor
    func onAppear() {
        biometricAuthRepository.biometryType.sink { [weak self] type in
            guard let self else { return }
            state.type = type
        }.store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
            guard let self else { return }
            Task {
                await self.requestBiometricsLogin()
            }
        }
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }

    /// 生体認証リクエスト
    @MainActor
    func requestBiometricsLogin() async {
        let result: Bool = await biometricAuthRepository.requestBiometrics()
        if result {
            showProgress()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                guard let self else { return }
                showApp()
            }
        }
    }

    /// パスワードログイン(keyChain)
    @MainActor
    func passwordLogin(password: [String], completion: @escaping (Bool) -> Void) {
        if password.count == 4 {
            showProgress()
            let pass = password.joined(separator: "")
            if pass == keyChainRepository.getData() {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self else { return }
                    showApp()
                }

            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self else { return }
                    hiddenProgress()
                    showFailureAlert()
                    completion(false)
                }
            }
        }
    }

    /// アプリトップへ遷移
    func showApp() {
        state.isShowApp = true
    }

    /// プログレス表示
    func showProgress() {
        state.isShowProgress = true
    }

    /// プログレス非表示
    func hiddenProgress() {
        state.isShowProgress = false
    }

    /// 失敗アラート表示
    func showFailureAlert() {
        state.isShowFailureAlert = true
    }
}
