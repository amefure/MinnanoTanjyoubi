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
    static private let isTest: Bool = false

    private let container = Container() { c in
        
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        
        
        // Add ViewModel
        c.register(InAppPurchaseViewModel.self) { r in
            InAppPurchaseViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }
            
        c.register(RootEnvironment.self) { r in
            RootEnvironment(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}

