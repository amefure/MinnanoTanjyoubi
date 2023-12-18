//
//  UserDefaultsRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import UIKit

class UserDefaultsKey {
//    static let APP_LOCK_KEY = "APP_LOCK_KEY"
}

class UserDefaultsRepository {
    static let sheard = UserDefaultsRepository()

    private let userDefaults = UserDefaults.standard

    /// Bool：保存
    public func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    public func getBoolData(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Int：保存
    public func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    public func getIntData(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
}
