//
//  AppLockInputViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/24.
//

import UIKit

@Observable
final class AppLockInputState {
    /// アプリメイン画面遷移
    var entryFlag: Bool = false
}

final class AppLockInputViewModel {
    var state = AppLockInputState()

    /// `Repository`
    private let keyChainRepository: KeyChainRepository

    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }

    func onAppear() {
        FBAnalyticsManager.loggingScreen(screen: .AppLockScreen)
    }

    func entryPassword(password: [String]) {
        state.entryFlag = true
        let pass = password.joined(separator: "")
        keyChainRepository.entry(value: pass)
    }
}
