//
//  SCYearAndMonth.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import UIKit

struct SCYearAndMonth: Identifiable {
    public var id: UUID = .init()
    public var year: Int
    public var month: Int

    public var yearAndMonth: String {
        return "\(year)年\(month)月"
    }
}
