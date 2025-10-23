//
//  DIContainer.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/20.
//

import Foundation
import Swinject

final class DIContainer: @unchecked Sendable {
    static let shared = DIContainer()

    // FIXME: モック切り替えフラグ
    private static let isTest: Bool = false

    private let container = Container { c in
        c.register(RealmRepository.self) { _ in RealmRepository() }
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(KeyChainRepository.self) { _ in KeyChainRepository() }
        c.register(BiometricAuthRepository.self) { _ in BiometricAuthRepository() }
        c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        c.register(RewardServiceProtocol.self) { _ in RewardService() }

        c.register(NotificationRequestManager.self) { _ in NotificationRequestManager() }
        c.register(WidgetCenterProtocol.self) { _ in WidgetCenterManager() }

        // Add ViewModel

        c.register(RootEnvironment.self) { r in
            RootEnvironment(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }

        c.register(RootListUserViewModel.self) { r in
            RootListUserViewModel(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!,
                widgetCenter: r.resolve(WidgetCenterProtocol.self)!
            )
        }

        c.register(EntryUserViewModel.self) { r in
            EntryUserViewModel(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!,
                widgetCenter: r.resolve(WidgetCenterProtocol.self)!
            )
        }

        c.register(DetailUserViewModel.self) { r in
            DetailUserViewModel(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!
            )
        }

        // Setting領域
        c.register(SettingViewModel.self) { r in
            SettingViewModel(
                repository: r.resolve(RealmRepository.self)!,
                keyChainRepository: r.resolve(KeyChainRepository.self)!
            )
        }

        c.register(EntryNotifyListViewModel.self) { r in
            EntryNotifyListViewModel(
                repository: r.resolve(RealmRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!
            )
        }

        c.register(InAppPurchaseViewModel.self) { r in
            InAppPurchaseViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }

        c.register(RewardViewModel.self) { r in
            RewardViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                rewardService: r.resolve(RewardServiceProtocol.self)!
            )
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}
