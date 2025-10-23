//
//  RootViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

/// アプリルートViewModel
class RootViewModel: ObservableObject {
    @Published private(set) var showCreateFailedError: Bool = false
    @Published var showCreateShareUserError: Bool = false
    @Published var showSuccessCreateUser: Bool = false

    @Published private(set) var error: ShareCreateError?
    @Published var createUsers: [User] = []

    private let repository: RealmRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
    }

    /// Custom URL Schemeでアプリを起動した場合のハンドリング
    func copyUserFromUrlScheme(url: URL) {
        guard let query = url.query() else { return }
        guard let users = decryptAndInitializeUsers(query) else { return }
        let unlockStorage = AppManager.sharedUserDefaultManager.getPurchasedUnlockStorage()
        if let error = shareCreateUsers(shareUsers: users, unlockStorage: unlockStorage) {
            showErrorAlert(error)
        } else {
            createUsers = users
            showSuccessCreateUser = true
            // 再取得
            NotificationCenter.default.post(name: .readAllUsers, object: true)
        }
    }

    /// 共有された暗号化された文字列から`User`オブジェクトを生成する
    /// - Parameter cipherText: 暗号化されたUserオブジェクトのJson形式
    /// - Returns: 共有された`User`オブジェクト
    private func decryptAndInitializeUsers(_ cipherText: String) -> [User]? {
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

    private func showErrorAlert(_ error: ShareCreateError) {
        self.error = error
        showCreateShareUserError = true
    }

    private func shareCreateUsers(shareUsers: [User], unlockStorage: Bool) -> ShareCreateError? {
        let users: [User] = repository.readAllObjs()

        let isOverCapacity = !isOverCapacity(baseSize: users.count, addSize: shareUsers.count)
        // 容量チェック && 容量解放されていないか
        guard isOverCapacity || unlockStorage else { return ShareCreateError.overCapacity }

        for user in shareUsers {
            // エラーが発生したら登録シーケンスを終了
            guard !(users.contains { $0.name == user.name }) else { return ShareCreateError.existUser }
            let copy = copyUser(user)
            repository.createObject(copy)
        }
        return nil
    }

    private func isOverCapacity(baseSize: Int, addSize: Int) -> Bool {
        let size = baseSize + addSize
        return size > AppManager.sharedUserDefaultManager.getCapacity()
    }

    private func copyUser(_ user: User) -> User {
        let copy = User()
        copy.name = user.name
        copy.ruby = user.ruby
        copy.date = user.date
        copy.relation = user.relation
        copy.memo = user.memo
        // alertとimagePathはコピーしない
        return copy
    }
}
