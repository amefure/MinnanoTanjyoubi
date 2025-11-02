//
//  SCYearAndMonth.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import UIKit

struct SCYearAndMonth: Identifiable, Sendable {
    let id: UUID = .init()
    let year: Int
    let month: Int
    var dates: [SCDate] = []

    var yearAndMonth: String {
        "\(year)年\(month)月"
    }
}
