//
//  UserCrudController.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import UIKit
import RealmSwift

class RealmCrudManager {
    
    private let realm = try! Realm()
    
    public var addUserId:ObjectId? = nil
    
    // MARK: - Create
    public func createUser(name:String,ruby:String,date:Date,relation:Relation,memo:String,alert:Bool){
        let user = User()
        user.name = name
        user.ruby = ruby
        user.date = date
        user.relation = relation
        user.memo = memo
        user.alert = alert
        
        try! realm.write{
            realm.add(user)
        }
        addUserId = user.id
    }
    
    // MARK: - Update
    public func updateUser(user:User,name:String,ruby:String,date:Date,relation:Relation,memo:String){
        try! realm.write{
            let result = realm.objects(User.self).where({$0.id == user.id}).first!
            result.name = name
            result.ruby = ruby
            result.date = date
            result.relation = relation
            result.memo = memo
        }
    }
    
    // MARK: - Remove
    public func removeUser(removeIdArray:[ObjectId]){
        
        try! realm.write{
            
            var records:[User] = []
            for targetId in removeIdArray{
                records += realm.objects(User.self).where{
                    $0.id == targetId
                }
            }
            realm.delete(records)
        }
    }
}
