//
//  ShareCreateError.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/15.
//

enum ShareCreateError: Error {
    /// ES001：既に同姓同名の誕生日情報が存在するエラー
    case existUser

    /// ES002：容量超過エラー
    case overCapacity

    public var title: String { "転送登録エラー" }

    public var message: String {
        return switch self {
        case .existUser:
            "共有された誕生日情報の登録に失敗しました。\nすでに同姓同名の誕生日情報が存在するため登録を中断しました。"
        case .overCapacity:
            "共有された誕生日情報の登録に失敗しました。\n保存容量が上限に達っするため登録を中断しました。"
        }
    }
}
