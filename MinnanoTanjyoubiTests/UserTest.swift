//
//  UserTest.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/05/17.
//

import Foundation
@testable import MinnanoTanjyoubi
import Testing

struct UserTest {
    private let user = User.createDemoUser(
        name: "吉田　真紘",
        ruby: "よしだ　まひろ",
        dateStr: "1994年12月21日",
        relation: .friend
    )

    // 検証対象の日付
    private let targetDay = "2000/3/12"

    /// あと何日
    @Test func daysLaterTest() {
        let dfm = DateFormatUtility(format: .slash)
        let date: Date = dfm.getDateNotNull(from: targetDay)
        let daysLater = UserCalcUtility.daysLater(from: user.date, today: date)
        #expect(daysLater == 284)
    }

    /// あと何ヶ月
    @Test func monthLaterTest() {
        let dfm = DateFormatUtility(format: .slash)
        let date: Date = dfm.getDateNotNull(from: targetDay)
        let monthLater = UserCalcUtility.monthLater(from: user.date, today: date)
        #expect(monthLater == 9)
    }

    /// 今何歳
    @Test func currentAgeTest() {
        let dfm = DateFormatUtility(format: .slash)
        let date: Date = dfm.getDateNotNull(from: targetDay)
        let currentAge = UserCalcUtility.currentAge(from: user.date, today: date)
        #expect(currentAge == 5)
    }

    /// 今何ヶ月
    @Test func currentAgeMonthTest() {
        let dfm = DateFormatUtility(format: .slash)
        let date: Date = dfm.getDateNotNull(from: targetDay)
        let currentAgeMonth = UserCalcUtility.currentAgeMonth(from: user.date, today: date)
        #expect(currentAgeMonth == 2)
    }

    /// 12星座
    @Test func signOfZodiacTest() {
        let signOfZodiac = UserCalcUtility.signOfZodiac(from: user.date)
        #expect(signOfZodiac == "いて座")
    }

    /// 十二支
    @Test func zodiacTest() {
        let zodiac = UserCalcUtility.zodiac(from: user.date)
        #expect(zodiac == "いぬ年")
    }
}
