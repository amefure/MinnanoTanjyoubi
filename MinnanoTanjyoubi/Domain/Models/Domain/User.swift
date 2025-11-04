//
//  User.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//
import Foundation
import RealmSwift
import SCCalendar

class User: Object, ObjectKeyIdentifiable, Codable, Identifiable, SCDateEntity {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var ruby: String = ""
    @Persisted var date: Date = .init()
    @Persisted var relation: Relation
    @Persisted var memo: String = ""
    /// 誕生日通知(`notification`とかのが良かったかも)
    @Persisted var alert: Bool = false
    @Persisted var imagePaths: RealmSwift.List<String>
    @Persisted var isYearsUnknown: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, ruby, date, relation, memo, alert, imagePaths, isYearsUnknown
    }

    convenience init(
        id: ObjectId,
        name: String,
        ruby: String,
        date: Date,
        relation: Relation,
        memo: String,
        alert: Bool,
        imagePaths: [String],
        isYearsUnknown: Bool
    ) {
        self.init()
        self.id = id
        self.name = name
        self.ruby = ruby
        self.date = date
        self.relation = relation
        self.memo = memo
        self.alert = alert
        self.imagePaths.append(objectsIn: imagePaths)
        self.isYearsUnknown = isYearsUnknown
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(ObjectId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        ruby = try container.decode(String.self, forKey: .ruby)
        date = try container.decode(Date.self, forKey: .date)
        relation = try container.decode(Relation.self, forKey: .relation)
        memo = try container.decode(String.self, forKey: .memo)
        alert = try container.decode(Bool.self, forKey: .alert)
        // ImagePathはデコード対象に含めない
        // let paths = try container.decode([String].self, forKey: .imagePaths)
        // imagePaths.append(objectsIn: paths)
        isYearsUnknown = try container.decode(Bool.self, forKey: .isYearsUnknown)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(ruby, forKey: .ruby)
        try container.encode(date, forKey: .date)
        try container.encode(relation, forKey: .relation)
        try container.encode(memo, forKey: .memo)
        try container.encode(alert, forKey: .alert)
        // ImagePathはエンコード対象に含めない
        // try container.encode(Array(imagePaths), forKey: .imagePaths)
        try container.encode(isYearsUnknown, forKey: .isYearsUnknown)
    }
}

extension User {
    /// 転送リンク
    /// `minnanotanjyoubi-app://create?birthday=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`
    static var demoUsers: [User] {
        let dfm = DateFormatUtility(format: .jp)
        var users: [User] = []

        let user = User.createDemoUser(
            name: "吉田　真紘",
            ruby: "よしだ　まひろ",
            dateStr: "1994年12月21日",
            relation: .friend
        )
        users.append(user)

        let user2 = User()
        user2.name = "長谷　慎二"
        user2.ruby = "はせ　しんじ"
        user2.date = dfm.getDateNotNull(from: "1990年3月3日")
        user2.relation = .work
        users.append(user2)

        let user3 = User()
        user3.name = "森山　美沙子"
        user3.ruby = "もりやま　みさこ"
        user3.date = dfm.getDateNotNull(from: "1994年5月12日")
        user3.relation = .friend
        users.append(user3)

        let user4 = User()
        user4.name = "中川　健太"
        user4.ruby = "なかがわ　けんた"
        user4.date = dfm.getDateNotNull(from: "2008年6月29日")
        user4.relation = .friend
        users.append(user4)

        let user5 = User()
        user5.name = "お父さん"
        user5.ruby = "おとうさん"
        user5.date = dfm.getDateNotNull(from: "1969年7月7日")
        user5.relation = .family
        users.append(user5)

        let user6 = User()
        user6.name = "お母さん"
        user6.ruby = "おかあさん"
        user6.date = dfm.getDateNotNull(from: "1977年1月9日")
        user6.relation = .family
        users.append(user6)

        let user7 = User()
        user7.name = "吉田　葵"
        user7.ruby = "よしだ　あおい"
        user7.date = dfm.getDateNotNull(from: "2018年8月15日")
        user7.relation = .friend
        users.append(user7)

        let user8 = User()
        user8.name = "川本　依"
        user8.ruby = "かわもと　より"
        user8.date = dfm.getDateNotNull(from: "2009年9月3日")
        user8.relation = .friend
        users.append(user8)

        let user9 = User()
        user9.name = "三谷　なぎさ"
        user9.ruby = "みたに　なぎさ"
        user9.date = dfm.getDateNotNull(from: "1995年8月11日")
        user9.relation = .friend
        users.append(user9)

        let user10 = User()
        user10.name = "笹島先輩"
        user10.ruby = "ささじませんぱい"
        user10.date = dfm.getDateNotNull(from: "1989年2月2日")
        user10.relation = .work
        users.append(user10)

        return users
    }

    /// デモユーザー作成
    static func createDemoUser(
        name: String,
        ruby: String,
        dateStr: String,
        relation: Relation
    ) -> User {
        let dfm = DateFormatUtility(format: .jp)
        let user = User()
        user.name = name
        user.ruby = ruby
        user.date = dfm.getDateNotNull(from: dateStr)
        user.relation = relation
        return user
    }
}
