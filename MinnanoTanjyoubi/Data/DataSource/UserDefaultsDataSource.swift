//
//  UserDefaultsDataSource.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2026/04/02.
//

import Foundation

protocol UserDefaultsDataSourceProtocol: Sendable {
    func set(_ value: Any?, forKey key: String)
    func bool(forKey key: String) -> Bool
    func integer(forKey key: String) -> Int
    func string(forKey key: String) -> String?
}

/// `UserDefaults`の基底クラス
/// スレッドセーフにするため `final class` + `Sendable`準拠
/// `UserDefaults`が`Sendable`ではないがスレッドセーフのため`@unchecked`で無視しておく
final class UserDefaultsDataSource: UserDefaultsDataSourceProtocol, @unchecked Sendable {
    /// `UserDefaults`がスレッドセーフではあるが`Sendable`ではないため`@unchecked`で回避
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    /// 保存
    func set(_ value: Any?, forKey key: String) { userDefaults.set(value, forKey: key) }
    /// Get method
    func bool(forKey key: String) -> Bool { userDefaults.bool(forKey: key) }
    func integer(forKey key: String) -> Int { userDefaults.integer(forKey: key) }
    func string(forKey key: String) -> String? { userDefaults.string(forKey: key) }
}
