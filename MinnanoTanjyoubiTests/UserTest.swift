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
    @Test func daysLaterTest() {
        let user = User.createDemoUser(
            name: "吉田　真紘",
            ruby: "よしだ　まひろ",
            dateStr: "1994年12月21日",
            relation: .friend
        )

        let dfm = DateFormatUtility()
        let date: Date = dfm.getSlashDate(from: "2000/3/12") ?? Date()

        let daysLater = UserCalcUtility.daysLater(from: user.date, today: date)
        #expect(daysLater == 284)
    }
}
