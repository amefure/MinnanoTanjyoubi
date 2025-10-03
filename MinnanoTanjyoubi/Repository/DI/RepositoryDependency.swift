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
    let realmRepository: RealmRepository
    let biometricAuthRepository: BiometricAuthRepository
    let keyChainRepository: KeyChainRepository
    let userDefaultsRepository: UserDefaultsRepository
    let inAppPurchaseRepository: InAppPurchaseRepository
    let scCalenderRepository: SCCalenderRepository

    // シングルトンインスタンスをここで保持する
    private static let sharedRealmRepository = RealmRepository()
    private static let sharedBiometricAuthRepository = BiometricAuthRepository()
    private static let sharedKeyChainRepository = KeyChainRepository()
    private static let sharedUserDefaultsRepository = UserDefaultsRepository()
    private static let sharedInAppPurchaseRepository = InAppPurchaseRepository()
    private static let sharedScCalenderRepository = SCCalenderRepository()

    init() {
        realmRepository = RepositoryDependency.sharedRealmRepository
        biometricAuthRepository = RepositoryDependency.sharedBiometricAuthRepository
        keyChainRepository = RepositoryDependency.sharedKeyChainRepository
        userDefaultsRepository = RepositoryDependency.sharedUserDefaultsRepository
        inAppPurchaseRepository = RepositoryDependency.sharedInAppPurchaseRepository
        scCalenderRepository = RepositoryDependency.sharedScCalenderRepository
    }
}
