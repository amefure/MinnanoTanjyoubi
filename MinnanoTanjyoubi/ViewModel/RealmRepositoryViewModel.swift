//
//  RealmRepositoryViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import RealmSwift
import UIKit

class RealmRepositoryViewModel: ObservableObject {
    static let shared = RealmRepositoryViewModel()
    private let repository = RealmRepository()

    @Published var users: [User] = []

    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        readAllUsers()
    }

    public func readAllUsers() {
        users.removeAll()
        let result = repository.readAllUsers()
        // 誕生日までの日付が近い順にソート
        users = Array(result).sorted(by: { $0.daysLater < $1.daysLater })
    }

    public func createUser(newUser: User) {
        repository.createUser(user: newUser)
        readAllUsers()
    }

    public func shareCreateUsers(shareUsers: [User]) -> ShareCreateError? {
        guard !isOverCapacity(shareUsers.count) else { return ShareCreateError.overCapacity }
        for user in shareUsers {
            // エラーが発生したら登録シーケンスを終了
            guard !(users.contains { $0.name == user.name }) else { return ShareCreateError.existUser }
            let copy = copyUser(user)
            repository.createUser(user: copy)
        }
        return nil
    }

    private func isOverCapacity(_ size: Int) -> Bool {
        let size = users.count + size
        return size > getMaxCapacity()
    }

    // 最大容量取得
    private func getMaxCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
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

    public func filteringUser(selectedRelation: Relation) {
        readAllUsers()
        users = users.filter { $0.relation == selectedRelation }
    }

    public func updateUser(id: ObjectId, newUser: User) {
        repository.updateUser(id: id, newUser: newUser)
        readAllUsers()
    }

    public func updateNotifyUser(id: ObjectId, notify: Bool) {
        repository.updateNotifyUser(id: id, notify: notify)
        readAllUsers()
    }

    public func updateImagePathsUser(id: ObjectId, imagePathsArray: [String]) {
        repository.updateImagePathsUser(id: id, imagePathsArray: imagePathsArray)
        readAllUsers()
    }

    public func removeUser(removeIdArray: [ObjectId]) {
        for id in removeIdArray {
            /// 削除対象の通知を全てOFFにする
            AppManager.sharedNotificationRequestManager.removeNotificationRequest(id)
        }
        repository.removeUser(removeIdArray: removeIdArray)
        readAllUsers()
    }
}
