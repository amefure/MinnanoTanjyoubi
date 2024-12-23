//
//  AppSortItem.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

enum AppSortItem: String, CaseIterable {
    case daysLater
    case nameAsce
    case nameDesc
    case ageAsce
    case ageeDesc
    case montheAsce
    case montheDesc

    public var name: String {
        return switch self {
        case .daysLater:
            "誕生日近い順"
        case .nameAsce:
            "名前(ふりがな)順 あ → ん"
        case .nameDesc:
            "名前(ふりがな)順 ん → あ"
        case .ageAsce:
            "年齢順 0歳 → 100歳"
        case .ageeDesc:
            "年齢順 100歳 → 0歳"
        case .montheAsce:
            "生まれ月順 1月 → 12月"
        case .montheDesc:
            "生まれ月順 12月 → 1月"
        }
    }
}
