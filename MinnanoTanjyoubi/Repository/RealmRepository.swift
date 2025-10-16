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

    func updateNotifyUser(id: ObjectId, notify: Bool) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else { return }
            result.alert = notify
        }
    }

    func appendImagePathUser(id: ObjectId, imagePath: String) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else { return }
            result.imagePaths.append(imagePath)
        }
    }
    
    func removeImagePathUser(id: ObjectId, imagePath: String) {
        try! realm.write {
            guard let result = realm.objects(User.self).where({ $0.id == id }).first else { return }
            guard let index = result.imagePaths.firstIndex(of: imagePath) else { return }
            result.imagePaths.remove(at: index)
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

            let users = oldRealm.objects(User.self)
            // データをコピー
            try newRealm.write {
                for obj in users {
                    newRealm.create(User.self, value: obj, update: .all)
                }
            }
            // コピー成功したら旧DBからデータを全て削除する
            try oldRealm.write {
                oldRealm.delete(users)
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


extension RealmRepository: RealmRepositoryProtocol {
    /// Create
    public func createObject<T: Object>(_ obj: T) {
        try? realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    /// Update
    public func updateObject<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void) {
        guard let obj = realm.object(ofType: objectType, forPrimaryKey: id) else { return }
        try? realm.write {
            updateBlock(obj)
        }
    }

    
    /// Read
    public func readAllObjs<T: Object>() -> Array<T> {
        let objs = realm.objects(T.self)
        // Deleteでクラッシュするため凍結させる
        let freezeObjs = objs.freeze().sorted(byKeyPath: "id", ascending: true)
        return Array(freezeObjs)
    }
    
    /// プライマリーキーで取得
    public func getByPrimaryKey<T: Object>(_ id: ObjectId) -> T? {
        let obj = realm.object(ofType: T.self, forPrimaryKey: id)
        return obj?.freeze()
    }
    
    /// Remove・削除対象指定
    public func removeObjs<T: Object & Identifiable>(list: [T]) {
        let ids = list.map(\.id)
        let predicate = NSPredicate(format: "id IN %@", ids)
        let objectsToDelete = realm.objects(T.self).filter(predicate)

        try? realm.write {
            realm.delete(objectsToDelete)
        }
    }
    
    /// Remove・削除対象指定
    /// 既にWriteトランザクションの中で削除処理を呼び出したい場合
    public func removeObjsInWrite<T: Object & Identifiable>(list: [T]) {
        let ids = list.map(\.id)
        let predicate = NSPredicate(format: "id IN %@", ids)
        let objectsToDelete = realm.objects(T.self).filter(predicate)

        realm.delete(objectsToDelete)
    }
    
    /// Remove：All削除
    public func removeAllObjs<T: Object & Identifiable>(_ objectType: T.Type) {
        let allObjs = realm.objects(T.self)
        // データがない場合は終了
        guard !allObjs.isEmpty else { return }
        try? realm.write {
            realm.delete(allObjs)
        }
    }
}

// MARK: Background Realm
extension RealmRepository {
    
    /// Create background
    public func createObjectBG<T: Object>(_ obj: T) {
        guard let realmBG = try? Realm() else { return }
        try? realmBG.write {
            realm.add(obj, update: .modified)
        }
    }
    
    /// Read background
    public func readAllObjsBG<T: Object>() -> Array<T> {
        guard let realmBG = try? Realm() else { return [] }
        let objs = realmBG.objects(T.self)
        // Deleteでクラッシュするため凍結させる
        let freezeObjs = objs.freeze().sorted(byKeyPath: "id", ascending: true)
        return Array(freezeObjs)
    }
    
    /// プライマリーキーで取得 background
    public func getByPrimaryKeyBG<T: Object>(_ id: ObjectId) -> T? {
        guard let realmBG = try? Realm() else { return nil }
        let obj = realmBG.object(ofType: T.self, forPrimaryKey: id)
        return obj?.freeze()
    }
    
    
    /// Update background
    public func updateObjectBG<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void) {
        guard let realmBG = try? Realm() else { return }
        guard let obj = realmBG.object(ofType: objectType, forPrimaryKey: id) else { return }
        try? realmBG.write {
            updateBlock(obj)
        }
    }
    
    /// Remove：All削除 background
    public func removeAllObjsBG<T: Object & Identifiable>(_ objectType: T.Type) {
        guard let realmBG = try? Realm() else { return }
        let allObjs = realmBG.objects(T.self)
        // データがない場合は終了
        guard !allObjs.isEmpty else { return }
        try? realmBG.write {
            realmBG.delete(allObjs)
        }
    }
}

