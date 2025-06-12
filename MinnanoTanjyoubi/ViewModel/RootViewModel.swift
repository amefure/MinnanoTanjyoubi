//
//  RootViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

class RootViewModel: ObservableObject {
    @Published private(set) var showCreateFailedError: Bool = false
    @Published var showCreateShareUserError: Bool = false
    @Published var showSuccessCreateUser: Bool = false

    @Published private(set) var error: ShareCreateError?
    @Published var createUsers: [User] = []

    /// 共有された暗号化された文字列から`User`オブジェクトを生成する
    /// - Parameter cipherText: 暗号化されたUserオブジェクトのJson形式
    /// - Returns: 共有された`User`オブジェクト
    public func decryptAndInitializeUsers(_ cipherText: String) -> [User]? {
        let jsonUtility = JsonConvertUtility()
        let cryptoUtility = CryptoUtillity()
        // 不要な`birthday=`部分を置換
        let cipherText = cipherText.replacingOccurrences(of: StaticUrls.QUERY_CREATE_USER, with: "")
        // 複合化
        guard let json = cryptoUtility.decryption(cipherText) else {
            showCreateFailedError = true
            return nil
        }
        // jsonをデコードしてUserオブジェクトに変換
        guard let users: [User] = jsonUtility.decode(json) else {
            showCreateFailedError = true
            return nil
        }
        return users
    }

    public func showErrorAlert(_ error: ShareCreateError) {
        self.error = error
        showCreateShareUserError = true
    }
}
