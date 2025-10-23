//
//  LayoutItem.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

enum LayoutItem: Int {
    case grid = 0
    case group = 1
    case calendar = 2

    var next: LayoutItem {
        switch self {
        case .grid:
            return .group
        case .group:
            return .calendar
        case .calendar:
            return .grid
        }
    }

    var imageName: String {
        switch self {
        case .grid:
            return "square.grid.3x3.fill"
        case .group:
            return "square.grid.3x1.below.line.grid.1x2.fill"
        case .calendar:
            return "calendar"
        }
    }
}
