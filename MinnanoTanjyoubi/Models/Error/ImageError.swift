//
//  ImageError.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import UIKit

enum ImageError: Error {
    /// EI001：保存失敗エラー
    case saveFailed

    /// EI002：削除失敗エラー
    case deleteFailed

    /// EI003：型変換失敗エラー(公開しない)
    case castFailed

    public var title: String { "画像操作エラー" }

    public var message: String {
        return switch self {
        case .saveFailed:
            "画像の保存に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        case .deleteFailed:
            "画像の削除に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        case .castFailed:
            "予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        }
    }
}
