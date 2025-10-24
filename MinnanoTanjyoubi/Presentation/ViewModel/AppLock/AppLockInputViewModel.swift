//
//  AppLockInputViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/24.
//

import UIKit

final class AppLockInputViewModel: ObservableObject {
    @Published var entryFlag: Bool = false

    /// `Repository`
    private let keyChainRepository: KeyChainRepository

    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }

    func onAppear() {
        FBAnalyticsManager.loggingScreen(screen: .AppLockScreen)
    }

    func entryPassword(password: [String]) {
        entryFlag = true
        let pass = password.joined(separator: "")
        keyChainRepository.entry(value: pass)
    }
}
