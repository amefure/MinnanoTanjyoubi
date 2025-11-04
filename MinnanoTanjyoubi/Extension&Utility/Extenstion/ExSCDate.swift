//
//  ExSCDate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SCCalendar
import UIKit

extension SCDate {
    /// 年月日取得
    func getDate() -> String {
        let dfm = DateFormatUtility(format: .jp)
        let str = dfm.getString(date: date ?? Date())
        return str
    }

    var users: [User] {
        entities.compactMap { $0.self as? User }
    }
}
