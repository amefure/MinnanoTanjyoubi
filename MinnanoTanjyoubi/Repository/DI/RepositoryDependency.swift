//
//  RepositoryDependency.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

/// `Repository` クラスのDIクラス
class RepositoryDependency {
    /// `Repository`
    public let realmRepository: RealmRepository
    public let biometricAuthRepository: BiometricAuthRepository
    public let keyChainRepository: KeyChainRepository
    public let userDefaultsRepository: UserDefaultsRepository
    public let inAppPurchaseRepository: InAppPurchaseRepository

    // シングルトンインスタンスをここで保持する
    private static let sharedRealmRepository = RealmRepository()
    private static let sharedBiometricAuthRepository = BiometricAuthRepository()
    private static let sharedKeyChainRepository = KeyChainRepository()
    private static let sharedUserDefaultsRepository = UserDefaultsRepository()
    private static let sharedInAppPurchaseRepository = InAppPurchaseRepository()

    init() {
        realmRepository = RepositoryDependency.sharedRealmRepository
        biometricAuthRepository = RepositoryDependency.sharedBiometricAuthRepository
        keyChainRepository = RepositoryDependency.sharedKeyChainRepository
        userDefaultsRepository = RepositoryDependency.sharedUserDefaultsRepository
        inAppPurchaseRepository = RepositoryDependency.sharedInAppPurchaseRepository
    }
}
