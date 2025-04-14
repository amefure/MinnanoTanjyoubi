//
//  User.swift
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
