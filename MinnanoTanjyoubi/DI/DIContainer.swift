//
//  DIContainer.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/20.
//

import Foundation
import SCCalendar
import Swinject

final class DIContainer: @unchecked Sendable {
    static let shared = DIContainer()

    // FIXME: モック切り替えフラグ
    private static let isTest: Bool = false

    private let container: Container

    private init() {
        container = Container { c in
            Self.registerRepositories(c)
            Self.registerServices(c)
            Self.registerViewModels(c)
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}

// MARK: - Repository Registration

private extension DIContainer {
    static func registerRepositories(_ c: Container) {
        // Repository
        c.register(RealmRepository.self) { _ in RealmRepository.shared }
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(KeyChainRepository.self) { _ in KeyChainRepository() }
        c.register(BiometricAuthRepository.self) { _ in BiometricAuthRepository() }
        c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        c.register(SCCalenderRepository.self) { _ in SCCalenderRepository(isMatchDataDayYear: false) }

        // Manager
        c.register(NotificationRequestManager.self) { _ in NotificationRequestManager() }
        c.register(WidgetCenterProtocol.self) { _ in WidgetCenterManager() }
        c.register(RemoteConfigManager.self) { _ in RemoteConfigManager.shared }
        c.register(RewardServiceProtocol.self) { _ in RewardService() }
    }
}

// MARK: - Service Registration

private extension DIContainer {
    static func registerServices(_ c: Container) {
        c.register(EntryUserServiceProtocol.self) { r in
            EntryUserService(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!,
                widgetCenter: r.resolve(WidgetCenterProtocol.self)!
            )
        }
    }
}

// MARK: - ViewModel Registration

private extension DIContainer {
    static func registerViewModels(_ c: Container) {
        // RootEnvironment
        c.register(RootEnvironment.self) { r in
            RootEnvironment(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                keyChainRepository: r.resolve(KeyChainRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!,
                remoteConfigManager: r.resolve(RemoteConfigManager.self)!
            )
        }

        c.register(RootViewModel.self) { r in
            RootViewModel(
                localRepository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
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

        // Entry
        c.register(EntryUserViewModel.self) { r in
            EntryUserViewModel(service: r.resolve(EntryUserServiceProtocol.self)!)
        }

        // Detail
        c.register(DetailUserViewModel.self) { r in
            DetailUserViewModel(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!
            )
        }

        // Calendar
        c.register(CalendarViewModel.self) { r in
            CalendarViewModel(
                localRepository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                scCalenderRepository: r.resolve(SCCalenderRepository.self)!
            )
        }

        // TutorialPopUp
        c.register(TutorialPopUpViewModel.self) { r in
            TutorialPopUpViewModel(
                localRepository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }

        // Setting
        c.register(SettingViewModel.self) { r in
            SettingViewModel(
                repository: r.resolve(RealmRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                keyChainRepository: r.resolve(KeyChainRepository.self)!
            )
        }

        // Setting > NotifyList
        c.register(EntryNotifyListViewModel.self) { r in
            EntryNotifyListViewModel(
                repository: r.resolve(RealmRepository.self)!,
                notificationRequestManager: r.resolve(NotificationRequestManager.self)!
            )
        }

        // Setting > NotifyMessage
        c.register(EditNotifyMessageViewModel.self) { r in
            EditNotifyMessageViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }

        // Setting > UpdateRelationName
        c.register(UpdateRelationNameViewModel.self) { r in
            UpdateRelationNameViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }

        // Setting > SelectSort
        c.register(SelectSortViewModel.self) { r in
            SelectSortViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }

        // Setting > SelectInitWeek
        c.register(SelectInitWeekViewModel.self) { r in
            SelectInitWeekViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }

        // Setting > ShareUserLink
        c.register(ShareUserLinkViewModel.self) { r in
            ShareUserLinkViewModel(
                localRepository: r.resolve(RealmRepository.self)!
            )
        }

        // Setting > Purchase
        c.register(InAppPurchaseViewModel.self) { r in
            InAppPurchaseViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }

        // Setting > Reward
        c.register(RewardViewModel.self) { r in
            RewardViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                rewardService: r.resolve(RewardServiceProtocol.self)!
            )
        }

        // Setting > AppLock
        c.register(AppLockViewModel.self) { r in
            AppLockViewModel(
                keyChainRepository: r.resolve(KeyChainRepository.self)!,
                biometricAuthRepository: r.resolve(BiometricAuthRepository.self)!
            )
        }

        // Setting > AppLockInput
        c.register(AppLockInputViewModel.self) { r in
            AppLockInputViewModel(
                keyChainRepository: r.resolve(KeyChainRepository.self)!
            )
        }
    }
}
