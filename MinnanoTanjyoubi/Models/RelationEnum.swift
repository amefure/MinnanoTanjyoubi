//
//  RelationEnum.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift

enum Relation: String,PersistableEnum,Identifiable,CaseIterable{
    
    var id:String{self.rawValue}
    
    case friend = "友達"
    case family = "家族"
    case school = "学校"
    case work = "仕事"
    case other = "その他"
}
