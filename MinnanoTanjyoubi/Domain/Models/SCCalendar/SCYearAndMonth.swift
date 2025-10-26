//
//  SCYearAndMonth.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import UIKit

struct SCYearAndMonth: Identifiable {
    var id: UUID = .init()
    var year: Int
    var month: Int

    var yearAndMonth: String {
        "\(year)年\(month)月"
    }
}
