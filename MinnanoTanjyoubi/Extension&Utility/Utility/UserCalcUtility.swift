//
//  UserCalcUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/06.
//

import UIKit

/// ユーザー情報の計算ユーティリティークラス
class UserCalcUtility {
    /// 今何歳
    static func currentAge(
        from: Date,
        today: Date = Date()
    ) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: from)
        let startToday = calendar.startOfDay(for: today)
        let ageComponents = calendar.dateComponents([.year], from: startDate, to: startToday)
        let age: Int = ageComponents.year ?? 0
        return age
    }

    /// 今何ヶ月
    static func currentAgeMonth(
        from: Date,
        today: Date = Date()
    ) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: from)
        let startToday = calendar.startOfDay(for: today)
        // yearやdayを指定しないとmonthで取得できる値がズレるので注意
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: startDate, to: startToday)
        let ageMonths: Int = ageComponents.month ?? 0
        return ageMonths
    }

    /// 12星座
    static func signOfZodiac(
        from: Date,
        dfm: DateFormatUtility = DateFormatUtility()
    ) -> String {
        let df = dfm.df
        // 年数は指定日の年数を取得→範囲を識別するため
        let thisYear = dfm.getSlashString(date: from).prefix(4)
        let nowYear = "\(thisYear)/" // "2023/" 形式
        let lateYear = "\(Int(thisYear)! + 1)/" // "2024/" 翌年形式

        switch from {
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
    static func zodiac(
        from: Date,
        dfm: DateFormatUtility = DateFormatUtility()
    ) -> String {
        let nowYear = dfm.getSlashString(date: from).prefix(4)
        guard let nowYearInt = Int(nowYear) else {
            // 文字列の場合
            return "..."
        }
        let num: Int = nowYearInt % 12
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

    /// 誕生日まであとX日
    static func daysLater(
        from: Date,
        today: Date = Date(),
        dfm: DateFormatUtility = DateFormatUtility()
    ) -> Int {
        let dateStr = dfm.getSlashString(date: from)
        let pre = dateStr.prefix(4)
        guard let range = dateStr.range(of: pre) else { return 0 }
        let nowYear = dfm.getSlashString(date: today).prefix(4)
        var replaceStr = dateStr.replacingCharacters(in: range, with: nowYear)

        var targetDate = dfm.getSlashDate(from: replaceStr)
        if targetDate == nil {
            // 日付変換失敗；閏年 →　3/1

            replaceStr = "\(nowYear)/3/1"
            targetDate = dfm.getSlashDate(from: replaceStr)
        }

        let num = targetDate!.timeIntervalSince(today)

        var result = ceil(num / (60 * 60 * 24))
        if result < 0 {
            result = result + 365
        }
        return Int(result)
    }

    /// 誕生日まであとXヶ月
    static func monthLater(
        from: Date,
        today: Date = Date(),
        dfm: DateFormatUtility = DateFormatUtility()
    ) -> Int? {
        let day = daysLater(from: from, today: today, dfm: dfm)
        guard day >= 30 else {
            return nil
        }
        return day / 30
    }
}
