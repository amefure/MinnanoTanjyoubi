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
        // defaultConfigurationを変更する前にマイグレーションを実行する
        Self.migrateRealmIfNeeded()
        // Realm全体で変化するようにdefaultConfigurationを更新する
        Realm.Configuration.defaultConfiguration = Self.appRealmConfig
        // テスト用
//        Realm.Configuration.defaultConfiguration = Self.appRealmConfigOLD
        realm = try! Realm()
    }

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

extension RealmRepository {
    /// 既存のRealmDB保存先からApp Groupsへmigrationする
    private static func migrateRealmIfNeeded() {
        AppLogger.logger.debug("==========================================")
        AppLogger.logger.debug("RealmDB保存先からApp Groupsへmigration処理開始")
        let fileManager = FileManager.default

        // 新Realm保存先が存在していても、中身が空なら移行する
        var needsMigration = false
        if fileManager.fileExists(atPath: appGroupsURL.path) {
            do {
                let newRealm = try Realm(configuration: appRealmConfig)
                if newRealm.isEmpty {
                    // 空ならマイグレーション
                    needsMigration = true
                }
            } catch {
                // Realmが開けなかったならマイグレーション
                needsMigration = true
            }
        } else {
            // 新Realm保存先のファイルが存在しないならマイグレーション
            needsMigration = true
        }

        // 新RealmDBファイルが存在しない or 存在するが空である場合
        guard needsMigration else {
            AppLogger.logger.debug("マイグレーション処理の終了：needsMigration")
            return
        }

        // 旧RealmDBファイルが存在する
        guard fileManager.fileExists(atPath: oldURL.path) else {
            AppLogger.logger.debug("マイグレーション処理の終了：Not oldURL.fileExists")
            return
        }

        do {
            // 旧 Realm を開く
            let oldConfig = Realm.Configuration(
                fileURL: oldURL,
                schemaVersion: RealmConfig.MIGRATION_VERSION
            )
            let oldRealm = try Realm(configuration: oldConfig)

            let newRealm = try Realm(configuration: appRealmConfig)

            // データをコピー
            try newRealm.write {
                for obj in oldRealm.objects(User.self) {
                    newRealm.create(User.self, value: obj, update: .all)
                }
            }
            AppLogger.logger.debug("✅ Realm データを共有コンテナに移行しました")
        } catch {
            AppLogger.logger.debug("❌ Realm 移行エラー: \(error)")
        }
        AppLogger.logger.debug("==========================================")
    }

    /// Realmデフォルトの保存先URL
    /// `Realm.Configuration.defaultConfiguration`を更新前に取得しないと変化してしまうので注意
    private static var oldURL: URL {
        // 旧 Realm の場所（デフォルトは Documents 配下）
        return Realm.Configuration.defaultConfiguration.fileURL!
            .deletingLastPathComponent()
            .appendingPathComponent("default.realm")
    }

    /// `App Groups`へ保存するためのURL
    private static var appGroupsURL: URL {
        let fileManager = FileManager.default
        // RealmDBの保存先をApp Groupsに変更する(Widgetと共有するため)
        return fileManager
            .containerURL(forSecurityApplicationGroupIdentifier: RealmConfig.APP_GROUP_ID)!
            .appendingPathComponent(RealmConfig.REALM_FILENAME)
    }

    /// アプリ全体で使用する`Realm.Configuration`
    /// `fileURL`には`App Groups`用のURL指定する
    private static var appRealmConfig: Realm.Configuration {
        return Realm.Configuration(
            fileURL: appGroupsURL,
            schemaVersion: RealmConfig.MIGRATION_VERSION
        )
    }

    /// テスト用のスキーマのみ変更している`Realm.Configuration`
    private static var appRealmConfigOLD: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: RealmConfig.MIGRATION_VERSION
        )
    }
}
