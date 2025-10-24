//
//  AppLockViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import Combine
import LocalAuthentication
import UIKit

final class AppLockViewModel: ObservableObject {
    /// アプリメイン画面遷移
    @Published var isShowApp = false
    /// パスワード失敗アラート
    @Published var isShowFailureAlert = false
    /// プログレス表示
    @Published private(set) var isShowProgress = false
    @Published private(set) var type: LABiometryType = .none
    @Published private(set) var isLogin = false

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
            guard let self = self else { return }
            self.type = type
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
                guard let self = self else { return }
                self.showApp()
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
                    self.showApp()
                }

            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self else { return }
                    self.hiddenProgress()
                    self.showFailureAlert()
                    completion(false)
                }
            }
        }
    }

    /// アプリトップへ遷移
    func showApp() {
        isShowApp = true
    }

    /// プログレス表示
    func showProgress() {
        isShowProgress = true
    }

    /// プログレス非表示
    func hiddenProgress() {
        isShowProgress = false
    }

    /// 失敗アラート表示
    func showFailureAlert() {
        isShowFailureAlert = true
    }
}
