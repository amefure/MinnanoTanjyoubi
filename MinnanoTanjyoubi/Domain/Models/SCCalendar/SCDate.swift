//
//  SCDate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct SCDate: Identifiable, @unchecked Sendable {
    var id: UUID = .init()
    var year: Int
    var month: Int
    var day: Int
    var date: Date?
    var week: SCWeek?
    var holidayName: String = ""
    /// 日付に持たせたいエンティティ
    var entities: [SCDateEntity] = []
    var isToday: Bool = false

    /// 年月日取得
    func getDate() -> String {
        let dfm = DateFormatUtility(format: .jp)
        let str = dfm.getString(date: date ?? Date())
        return str
    }

    func dayColor(defaultColor: Color = .gray) -> Color {
        guard let week else { return defaultColor }
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
    var users: [User] {
        entities.compactMap { $0.self as? User }
    }
}

extension SCDate {
    static let demo: SCDate = .init(year: 2024, month: 12, day: 25, isToday: true)
}
