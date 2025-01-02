//
//  ProductItem.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/30.
//

enum ProductItem {
    case removeAds
    case unlockStorage

    public var id: String {
        return switch self {
        case .removeAds:
            SecretProductIdKey.REMOVE_ADS
        case .unlockStorage:
            SecretProductIdKey.UNLOCK_STORAGE
        }
    }

    static func get(id: String) -> ProductItem? {
        switch id {
        case ProductItem.removeAds.id:
            return .removeAds
        case ProductItem.unlockStorage.id:
            return .unlockStorage
        default:
            return nil
        }
    }
}
