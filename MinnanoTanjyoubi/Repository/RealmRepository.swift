//
//  RealmRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

@preconcurrency
import RealmSwift
import UIKit

final class RealmRepository: Sendable {
    init() {
        let config = Realm.Configuration(schemaVersion: RealmConfig.MIGRATION_VERSION)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }

    // MARK: - private property

    private let realm: Realm

    // MARK: - Create

    public func createUser(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }

    // MARK: - Read

    public func readAllUsers() -> Results<User> {
        try! realm.write {
            let users = realm.objects(User.self)
            // Deleteでクラッシュするため凍結させる
            return users.freeze().sorted(byKeyPath: "id", ascending: true)
        }
    }

    // MARK: - Update

    public func updateUser(id: ObjectId, newUser: User) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else {
                return
            }
            result.name = newUser.name
            result.ruby = newUser.ruby
            result.date = newUser.date
            result.relation = newUser.relation
            result.memo = newUser.memo
            result.isYearsUnknown = newUser.isYearsUnknown
        }
    }

    public func updateNotifyUser(id: ObjectId, notify: Bool) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else {
                return
            }
            result.alert = notify
        }
    }

    public func updateImagePathsUser(id: ObjectId, imagePathsArray: [String]) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else {
                return
            }
            let imagePaths = RealmSwift.List<String>()
            imagePaths.append(objectsIn: imagePathsArray)
            result.imagePaths = imagePaths
        }
    }

    // MARK: - Remove

    public func removeUser(removeIdArray: [ObjectId]) {
        try! realm.write {
            var records: [User] = []
            for targetId in removeIdArray {
                records += realm.objects(User.self).where {
                    $0.id == targetId
                }
            }
            realm.delete(records)
        }
    }
}
