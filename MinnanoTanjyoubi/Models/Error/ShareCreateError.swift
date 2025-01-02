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
            "すでに同姓同名の誕生日情報が存在するため登録を中断しました。"
        case .overCapacity:
            "転送情報を全て登録すると保存容量が上限に達っしてしまうため登録を中断しました。\n容量を増加するか残量の範囲内で転送情報を受け取ってください。"
        }
    }
}
