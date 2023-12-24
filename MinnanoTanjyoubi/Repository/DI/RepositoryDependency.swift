//
//  RepositoryDependency.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

class RepositoryDependency {
    public let biometricAuthRepository = BiometricAuthRepository()
    public let keyChainRepository = KeyChainRepository()
    public let userDefaultsRepository = UserDefaultsRepository()
}
