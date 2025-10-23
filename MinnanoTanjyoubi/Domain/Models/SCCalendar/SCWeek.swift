//
//  SCWeek.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI
import UIKit

enum SCWeek: Int, CaseIterable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6

    var fullSymbols: String {
        switch self {
        case .sunday: return "日曜日"
        case .monday: return "月曜日"
        case .tuesday: return "火曜日"
        case .wednesday: return "水曜日"
        case .thursday: return "木曜日"
        case .friday: return "金曜日"
        case .saturday: return "土曜日"
        }
    }

    var shortSymbols: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }

    var color: Color? {
        switch self {
        case .sunday: return .red
        case .saturday: return .blue
        default: return nil
        }
    }
}

extension Array where Element == SCWeek {
    mutating func moveWeekToFront(_ week: SCWeek) {
        guard let index = firstIndex(of: week) else { return }
        self = Array(self[index...] + self[..<index])
    }
}
