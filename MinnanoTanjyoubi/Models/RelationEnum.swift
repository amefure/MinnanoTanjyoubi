//
//  RelationEnum.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift

enum Relation: String, PersistableEnum, Identifiable, CaseIterable {
    var id: String { rawValue }

    case friend = "友達"
    case family = "家族"
    case school = "学校"
    case work = "仕事"
    case other = "その他"
    case sns = "SNS"

    public var relationIndex: Int {
        return switch self {
        case .friend:
            0
        case .family:
            1
        case .school:
            2
        case .work:
            3
        case .other:
            4
        case .sns:
            5
        }
    }

    static func getIndexbyRelation(_ index: Int) -> Relation {
        return switch index {
        case 0:
            Relation.friend
        case 1:
            Relation.family
        case 2:
            Relation.school
        case 3:
            Relation.work
        case 4:
            Relation.other
        case 5:
            Relation.sns
        default:
            Relation.other
        }
    }
}

enum RelationConfig {
    static let FRIEND_NAME = Relation.friend.rawValue
    static let FAMILY_NAME = Relation.family.rawValue
    static let SCHOOL_NAME = Relation.school.rawValue
    static let WORK_NAME = Relation.work.rawValue
    static let OTHER_NAME = Relation.other.rawValue
    static let SNS_NAME = Relation.sns.rawValue
}
