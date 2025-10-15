//
//  RealmRepositoryProtocol.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/15.
//

import RealmSwift

protocol RealmRepositoryProtocol {
    // Create
    func createObject<T: Object>(_ obj: T)
    func createObjectBG<T: Object>(_ obj: T)

    // Read
    func readAllObjs<T: Object>() -> [T]
    func readAllObjsBG<T: Object>() -> [T]

    func getByPrimaryKey<T: Object>(_ id: ObjectId) -> T?
    func getByPrimaryKeyBG<T: Object>(_ id: ObjectId) -> T?

    // Update
    func updateObject<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void)
    func updateObjectBG<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void)

    // Delete
    func removeObjs<T: Object & Identifiable>(list: [T])
    func removeAllObjs<T: Object & Identifiable>(_ objectType: T.Type)
    func removeAllObjsBG<T: Object & Identifiable>(_ objectType: T.Type)
}
