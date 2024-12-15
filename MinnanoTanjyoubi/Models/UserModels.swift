//
//  UserModels.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift

class User: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var ruby: String = ""
    @Persisted var date: Date = .init()
    @Persisted var relation: Relation
    @Persisted var memo: String = ""
    @Persisted var alert: Bool = false
    @Persisted var imagePaths: RealmSwift.List<String>

    enum CodingKeys: String, CodingKey {
        case id, name, ruby, date, relation, memo, alert, imagePaths
    }

    convenience init(
        id: ObjectId,
        name: String,
        ruby: String,
        date: Date,
        relation: Relation,
        memo: String,
        alert: Bool,
        imagePaths: [String]
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
    }
}

extension User {
    /// 誕生日まであとX日
    public var daysLater: Int {
        let dfm = DateFormatUtility()
        let dateStr = dfm.getSlashString(date: date)
        let pre = dateStr.prefix(4)
        let range = dateStr.range(of: pre)
        let nowYear = dfm.getSlashString(date: dfm.today).prefix(4)
        var replaceStr = dateStr.replacingCharacters(in: range!, with: nowYear)

        var targetDate = dfm.getSlashDate(from: replaceStr)
        if targetDate == nil {
            // 日付変換失敗；閏年 →　3/1

            replaceStr = "\(nowYear)/3/1"
            targetDate = dfm.getSlashDate(from: replaceStr)
        }

        let num = targetDate!.timeIntervalSince(dfm.today)

        var result = ceil(num / (60 * 60 * 24))
        if result < 0 {
            result = result + 365
        }
        return Int(result)
    }

    /// 誕生日まであとXヶ月
    public var monthLater: Int? {
        let day = daysLater
        if day < 30 {
            return nil
        } else {
            let month = day / 30
            return month
        }
    }

    /// 今何歳
    public var currentAge: Int {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: date)
        let startToday = calendar.startOfDay(for: Date())
        let ageComponents = calendar.dateComponents([.year], from: startDate, to: startToday)
        let age = ageComponents.year ?? 0

        return age
    }

    /// 今何ヶ月
    public var currentAgeMonth: Int {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: date)
        let startToday = calendar.startOfDay(for: Date())
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: startDate, to: startToday)
        let ageMonths = ageComponents.month ?? 0
        return ageMonths
    }

    /// 12星座
    public var signOfZodiac: String {
        let dfm = DateFormatUtility()
        let df = dfm.df
        // 年数は指定日の年数を取得→範囲を識別するため
        let thisYear = dfm.getSlashString(date: date).prefix(4)
        let nowYear = "\(thisYear)/" // "2023/" 形式
        let lateYear = "\(Int(thisYear)! + 1)/" // "2024/" 翌年形式

        switch date {
        case df.date(from: String(nowYear + "3/21"))! ... df.date(from: String(nowYear + "4/20"))!:
            return "おひつじ座"
        case df.date(from: String(nowYear + "4/20"))! ... df.date(from: String(nowYear + "5/21"))!:
            return "おうし座"
        case df.date(from: String(nowYear + "5/21"))! ... df.date(from: String(nowYear + "6/22"))!:
            return "ふたご座"
        case df.date(from: String(nowYear + "6/22"))! ... df.date(from: String(nowYear + "7/23"))!:
            return "かに座"
        case df.date(from: String(nowYear + "7/23"))! ... df.date(from: String(nowYear + "8/23"))!:
            return "しし座"
        case df.date(from: String(nowYear + "8/23"))! ... df.date(from: String(nowYear + "9/23"))!:
            return "おとめ座"
        case df.date(from: String(nowYear + "9/23"))! ... df.date(from: String(nowYear + "10/24"))!:
            return "てんびん座"
        case df.date(from: String(nowYear + "10/24"))! ... df.date(from: String(nowYear + "11/23"))!:
            return "さそり座"
        case df.date(from: String(nowYear + "11/23"))! ... df.date(from: String(nowYear + "12/22"))!:
            return "いて座"
        case df.date(from: String(nowYear + "12/22"))! ... df.date(from: String(lateYear + "1/1"))!:
            return "やぎ座"
        case df.date(from: String(nowYear + "1/1"))! ... df.date(from: String(nowYear + "1/20"))!:
            return "やぎ座"
        case df.date(from: String(nowYear + "1/20"))! ... df.date(from: String(nowYear + "2/19"))!:
            return "みずがめ座"
        case df.date(from: String(nowYear + "2/19"))! ... df.date(from: String(nowYear + "3/21"))!:
            return "うお座"
        default:
            return "..."
        }
    }

    ///  十二支
    public var zodiac: String {
        let dfm = DateFormatUtility()
        let nowYear = dfm.getSlashString(date: date).prefix(4)
        guard let nowYearInt = Int(nowYear) else {
            // 文字列の場合
            return "..."
        }
        let num = nowYearInt % 12
        switch num {
        case 4:
            return "ねずみ年"
        case 5:
            return "うし年"
        case 6:
            return "とら年"
        case 7:
            return "うさぎ年"
        case 8:
            return "たつ年"
        case 9:
            return "へび年"
        case 10:
            return "うま年"
        case 11:
            return "ひつじ年"
        case 0:
            return "さる年"
        case 1:
            return "とり年"
        case 2:
            return "いぬ年"
        case 3:
            return "いのしし年"
        default:
            return "..."
        }
    }
}

extension User {
    /// 転送リンク
    /// `minnanotanjyoubi-app://create?birthday=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`
    static var demoUsers: [User] {
        let dfm = DateFormatUtility()
        var users: [User] = []

        let user = User()
        user.name = "吉田　真紘"
        user.ruby = "よしだ　まひろ"
        user.date = dfm.getJpDate(from: "1994年12月21日")
        user.relation = .friend
        users.append(user)

        let user2 = User()
        user2.name = "長谷　慎二"
        user2.ruby = "はせ　しんじ"
        user2.date = dfm.getJpDate(from: "1990年3月3日")
        user2.relation = .work
        users.append(user2)

        let user3 = User()
        user3.name = "森山　美沙子"
        user3.ruby = "もりやま　みさこ"
        user3.date = dfm.getJpDate(from: "1994年5月12日")
        user3.relation = .friend
        users.append(user3)

        let user4 = User()
        user4.name = "中川　健太"
        user4.ruby = "なかがわ　けんた"
        user4.date = dfm.getJpDate(from: "2008年6月29日")
        user4.relation = .friend
        users.append(user4)

        let user5 = User()
        user5.name = "お父さん"
        user5.ruby = "おとうさん"
        user5.date = dfm.getJpDate(from: "1969年7月7日")
        user5.relation = .family
        users.append(user5)

        let user6 = User()
        user6.name = "お母さん"
        user6.ruby = "おかあさん"
        user6.date = dfm.getJpDate(from: "1977年1月9日")
        user6.relation = .family
        users.append(user6)

        let user7 = User()
        user7.name = "吉田　葵"
        user7.ruby = "よしだ　あおい"
        user7.date = dfm.getJpDate(from: "2018年8月15日")
        user7.relation = .friend
        users.append(user7)

        let user8 = User()
        user8.name = "川本　依"
        user8.ruby = "かわもと　より"
        user8.date = dfm.getJpDate(from: "2009年9月3日")
        user8.relation = .friend
        users.append(user8)

        let user9 = User()
        user9.name = "三谷　なぎさ"
        user9.ruby = "みたに　なぎさ"
        user9.date = dfm.getJpDate(from: "1995年8月11日")
        user9.relation = .friend
        users.append(user9)

        let user10 = User()
        user10.name = "笹島先輩"
        user10.ruby = "ささじませんぱい"
        user10.date = dfm.getJpDate(from: "1989年2月2日")
        user10.relation = .work
        users.append(user10)

        return users
    }
}
