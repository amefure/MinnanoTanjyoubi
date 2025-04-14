//
//  EntryUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import UIKit

class EntryUserViewModel {
    /// バリデーション
    public func validationInput(_ name: String) -> Bool {
        return name != ""
    }

    public func getNewUser(
        name: String,
        ruby: String,
        date: Date,
        selectedRelation: Relation,
        memo: String,
        alert: Bool,
        isYearsUnknown: Bool
    ) -> User {
        let newUser = User()
        newUser.name = name
        newUser.ruby = ruby
        newUser.date = date
        newUser.relation = selectedRelation
        newUser.memo = memo
        newUser.alert = alert
        newUser.isYearsUnknown = isYearsUnknown
        return newUser
    }

    /// 保存された年数のDateオブジェクトを取得
    public func getInitYearDate() -> Date {
        let dfm = DateFormatUtility()
        let year = AppManager.sharedUserDefaultManager.getEntryInitYear()
        let yearDate = dfm.setYearDate(year: year)
        return yearDate
    }
}
