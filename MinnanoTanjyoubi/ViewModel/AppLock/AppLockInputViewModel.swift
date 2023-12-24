//
//  AppLockInputViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/24.
//

import UIKit

class AppLockInputViewModel: ObservableObject {
    @Published var entryFlag: Bool = false

    private let keyChainRepository: KeyChainRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
    }

    public func entryPassword(password: [String]) {
        entryFlag = true
        let pass = password.joined(separator: "")
        keyChainRepository.entry(value: pass)
    }
}
