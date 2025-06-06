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

    private let dfm = DateFormatUtility()

    /// あと何日
    @Test func daysLaterTest() {
        let date: Date = dfm.getSlashDate(from: "2000/3/12") ?? Date()
        let daysLater = UserCalcUtility.daysLater(from: user.date, today: date)
        #expect(daysLater == 284)
    }

    /// 今何歳
    @Test func currentAgeTest() {
        let date: Date = dfm.getSlashDate(from: "2000/3/12") ?? Date()
        let currentAge = UserCalcUtility.currentAge(from: user.date, today: date)
        #expect(currentAge == 5)
    }

    /// 今何ヶ月
    @Test func currentAgeMonthTest() {
        let date: Date = dfm.getSlashDate(from: "2000/3/12") ?? Date()
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
