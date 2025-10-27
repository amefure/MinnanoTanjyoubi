//
//  RootViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

@Observable
final class RootViewState {
    var isShowShareCreateFailedAlert: Bool = false
    var isShowShareCreateSuccessAlert: Bool = false

    private(set) var shareCreateError: ShareCreateError = .other
    var createUsers: [User] = []

    fileprivate func showShareCreateFailedAlert(_ error: ShareCreateError) {
        shareCreateError = error
        isShowShareCreateSuccessAlert = true
    }
}

/// アプリルートViewModel

final class RootViewModel {
    var state = RootViewState()

    private let localRepository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository

    init(
        localRepository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.localRepository = localRepository
        self.userDefaultsRepository = userDefaultsRepository
    }

    /// Custom URL Schemeでアプリを起動した場合のハンドリング
    func copyUserFromUrlScheme(url: URL) {
        guard let query = url.query() else { return }
        guard let users = decryptAndInitializeUsers(query) else { return }
        let unlockStorage = userDefaultsRepository.getPurchasedUnlockStorage()
        let result = shareCreateUsers(shareUsers: users, unlockStorage: unlockStorage)
        switch result {
        case .success:
            state.createUsers = users
            state.isShowShareCreateSuccessAlert = true
            // 再取得
            NotificationCenter.default.post(name: .readAllUsers, object: true)
        case let .failure(error):
            showErrorAlert(error)
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
            state.showShareCreateFailedAlert(.other)
            return nil
        }
        // jsonをデコードしてUserオブジェクトに変換
        guard let users: [User] = jsonUtility.decode(json) else {
            state.showShareCreateFailedAlert(.other)
            return nil
        }
        return users
    }

    private func showErrorAlert(_ error: ShareCreateError) {
        state.showShareCreateFailedAlert(error)
    }

    private func shareCreateUsers(
        shareUsers: [User],
        unlockStorage: Bool
    ) -> Result<Void, ShareCreateError> {
        let users: [User] = localRepository.readAllObjs()

        let isOverCapacity = !isOverCapacity(baseSize: users.count, addSize: shareUsers.count)
        // 容量チェック && 容量解放されていないか
        guard isOverCapacity || unlockStorage else { return .failure(ShareCreateError.overCapacity) }

        for user in shareUsers {
            // エラーが発生したら登録シーケンスを終了
            guard !(users.contains { $0.name == user.name }) else { return .failure(ShareCreateError.existUser) }
            let copy = copyUser(user)
            localRepository.createObject(copy)
        }
        return .success(())
    }

    private func isOverCapacity(baseSize: Int, addSize: Int) -> Bool {
        let size = baseSize + addSize
        return size > userDefaultsRepository.getCapacity()
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
