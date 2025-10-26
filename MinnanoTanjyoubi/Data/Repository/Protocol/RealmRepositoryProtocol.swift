//
//  RealmRepositoryProtocol.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/15.
//

import RealmSwift

protocol RealmRepositoryProtocol {
    // Create
    func createObject(_ obj: some Object)
    func createObjectBG(_ obj: some Object)

    // Read
    func readAllObjs<T: Object>() -> [T]
    func readAllObjsBG<T: Object>() -> [T]

    func getByPrimaryKey<T: Object>(_ id: ObjectId) -> T?
    func getByPrimaryKeyBG<T: Object>(_ id: ObjectId) -> T?

    // Update
    func updateObject<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void)
    func updateObjectBG<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void)

    // Delete
    func removeObjs(list: [some Object & Identifiable])
    func removeAllObjs(_ objectType: (some Object & Identifiable).Type)
    func removeAllObjsBG(_ objectType: (some Object & Identifiable).Type)
}
