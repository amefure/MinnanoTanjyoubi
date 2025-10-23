//
//  NotifyDate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/04/14.
//

enum NotifyDate: String, CaseIterable {
    case onTheDay = "0"
    case before1 = "1"
    case before2 = "2"
    case before3 = "3"
    case before4 = "4"
    case before5 = "5"
    case before6 = "6"
    case before7 = "7"

    /// 日付に変換
    private var dayNum: Int {
        return Int(rawValue) ?? 1
    }

    /// タイトル
    var title: String {
        return switch self {
        case .onTheDay:
            "当日"
        default:
            "\(dayNum)日前"
        }
    }
}
