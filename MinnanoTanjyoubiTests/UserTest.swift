//
//  UserTest.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/05/17.
//

import Foundation
import Testing

struct UserTest {
    @Test func daysLaterTest() {
        let user = User.createDemoUser(
            name: "吉田　真紘",
            ruby: "よしだ　まひろ",
            dateStr: "1994年12月21日",
            relation: .friend
        )
        let daysLater = fetchDaysLater(date: user.date)
        #expect(daysLater == user.daysLater)
    }

    /// 誕生日まであとX日
    public func fetchDaysLater(date: Date) -> Int {
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
}
