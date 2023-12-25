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

    public func removeUser(removeIdArray: [ObjectId]) {
        for id in removeIdArray {
            /// 削除対象の通知を全てOFFにする
            AppManager.sharedNotificationRequestManager.removeNotificationRequest(id)
        }
        repository.removeUser(removeIdArray: removeIdArray)
        readAllUsers()
    }
}
