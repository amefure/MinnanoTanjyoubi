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

    init() {
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

    public func shareCreateUser(shareUser: User) -> Bool {
        guard !(users.contains { $0.name == shareUser.name }) else {
            print("同姓同名の誕生日が既に登録されています")
            return false
        }
        let copy = copyUser(shareUser)
        print("createUser", copy)
        repository.createUser(user: copy)
        return true
    }

    private func copyUser(_ user: User) -> User {
        let copy = User()
        copy.name = user.name
        copy.ruby = user.ruby
        copy.date = user.date
        copy.relation = user.relation
        copy.memo = user.memo
        // alertとimagePathはコピーしなし
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
