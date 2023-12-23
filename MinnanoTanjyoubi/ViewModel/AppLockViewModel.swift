//
//  AppLockViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import Combine
import LocalAuthentication
import UIKit

class AppLockViewModel: ObservableObject {
    @Published var isShowApp = false // アプリメイン画面遷移
    @Published var isShowFailureAlert = false // パスワード失敗アラート
    @Published private(set) var isShowProgress = false // プログレス表示
    @Published private(set) var type: LABiometryType = .none
    @Published private(set) var isLogin = false

    private let biometricAuthRepository: BiometricAuthRepository
    private let keyChainRepository: KeyChainRepository

    private var cancellables: Set<AnyCancellable> = []

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        biometricAuthRepository = repositoryDependency.biometricAuthRepository
        keyChainRepository = repositoryDependency.keyChainRepository
    }

    public func onAppear() {
        biometricAuthRepository.biometryType.sink { [weak self] type in
            guard let self = self else { return }
            self.type = type
        }.store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.requestBiometricsLogin()
        }
    }

    /// 生体認証リクエスト
    public func requestBiometricsLogin() {
        biometricAuthRepository.requestBiometrics { [weak self] result in
            guard let self = self else { return }
            if result {
                self.showProgress()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.showApp()
                }
            }
        }
    }

    /// パスワードログイン(keyChain)
    public func passwordLogin(password: [String], completion: @escaping (Bool) -> Void) {
        if password.count == 4 {
            showProgress()
            let pass = password.joined(separator: "")
            if pass == keyChainRepository.getData() {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.showApp()
                }

            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.hiddenProgress()
                    self.showFailureAlert()
                    completion(false)
                }
            }
        }
    }

    /// アプリトップへ遷移
    public func showApp() {
        isShowApp = true
    }

    /// プログレス表示
    public func showProgress() {
        isShowProgress = true
    }

    /// プログレス非表示
    public func hiddenProgress() {
        isShowProgress = false
    }

    /// 失敗アラート表示
    public func showFailureAlert() {
        isShowFailureAlert = true
    }
}
