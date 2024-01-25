//
//  RootViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

class RootViewModel: ObservableObject {
    @Published var appLocked: Bool = false

    private let keyChainRepository: KeyChainRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        checkAppLock()
    }

    /// アプリにロックがかけてあるかをチェック
    private func checkAppLock() {
        appLocked = keyChainRepository.getData().count == 4
    }
}
