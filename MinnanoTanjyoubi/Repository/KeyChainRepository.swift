//
//  KeyChainRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import UIKit

class KeyChainRepository {
    static let sheard = KeyChainRepository()

    /// データ登録/更新
    public func entry(value: String) {
        guard let data = value.data(using: .utf8) else { print("NO")
            return
        }
        guard let bundleId = Bundle.main.bundleIdentifier else { print("NOID")
            return
        }

        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: bundleId,
        ] as CFDictionary

        let status = SecItemCopyMatching(query, nil)

        switch status {
        case errSecItemNotFound:
            // 登録
            SecItemAdd(query, nil)
        case errSecSuccess:
            // 更新
            SecItemUpdate(query, [kSecValueData: data] as CFDictionary)
        default:
            print("Error")
        }
    }

    /// データ取得
    public func getData() -> String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: bundleId,
            kSecReturnData: true,
        ] as CFDictionary

        var result: AnyObject?
        _ = SecItemCopyMatching(query, &result)
        if let data = result as? Data {
            if let pass = String(data: data, encoding: .utf8) {
                /// 念の為パスワードではない値があった場合に対応
                if pass.count == 4 {
                    return pass
                }
            }
        }
        return ""
    }

    /// データ削除
    public func delete() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: bundleId,
        ] as CFDictionary

        _ = SecItemDelete(query)
    }
}
