//
//  RootViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

class RootViewModel {
    private let keyChainRepository: KeyChainRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
    }

    /// アプリにロックがかけてあるかをチェック
    public func checkAppLock() -> Bool {
        keyChainRepository.getData().count == 4
    }
}
