//
//  UserModels.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var ruby: String = ""
    @Persisted var date: Date = .init()
    @Persisted var relation: Relation
    @Persisted var memo: String = ""
    @Persisted var alert: Bool = false

    // MARK: - 計算プロパティ

    /// 誕生日まであとX日
    public var daysLater: Int {
        let dfm = DateFormatManager()
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
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        let age = ageComponents.year ?? 0

        return age
    }

    /// 12星座
    public var signOfZodiac: String {
        let dfm = DateFormatManager()
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
        let dfm = DateFormatManager()
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
    static var demoUsers: [User] {
        let dfm = DateFormatManager()
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
