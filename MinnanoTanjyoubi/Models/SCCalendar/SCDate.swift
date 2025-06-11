//
//  SCDate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct SCDate: Identifiable {
    public var id: UUID = .init()
    public var year: Int
    public var month: Int
    public var day: Int
    public var date: Date?
    public var week: SCWeek?
    public var holidayName: String = ""
    // 登録されている誕生日情報
    public var users: [User] = []
    public var isToday: Bool = false

    /// 年月日取得
    public func getDate(format _: String = "yyyy-M-d") -> String {
        let str = DateFormatUtility().getJpString(date: date ?? Date())
        return str
    }

    public func dayColor(defaultColor: Color = .gray) -> Color {
        guard let week = week else { return defaultColor }
        if !holidayName.isEmpty { return .red }
        if week == .saturday {
            return .blue
        } else if week == .sunday {
            return .red
        } else {
            return defaultColor
        }
    }
}

extension SCDate {
    static let demo: SCDate = .init(year: 2024, month: 12, day: 25, isToday: true)
}
