//
//  JsonConvertUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/12.
//

import UIKit

/// JSONエンコード/デコードクラス
class JsonConvertUtility {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    /// `T: Codable`をJSON文字列に変換する
    /// - Parameter data: `Codable`に適合した型
    /// - Returns: JSON文字列
    func convertJson<T: Codable>(_ data: T) -> String? {
        // encoder.outputFormatting = .prettyPrinted // インデントで読みやすくする
        guard let jsonData = try? encoder.encode(data) else { return nil }
        guard let json = String(data: jsonData, encoding: .utf8) else { return nil }
        return json
    }

    /// JSON文字列を`T: Codable`を変換する
    /// - Parameter json: JSON文字列
    /// - Returns: 対象データクラス
    func decode<T: Codable>(_ json: String) -> T? {
        guard let jsonData = String(json).data(using: .utf8) else { return nil }
        guard let model = try? decoder.decode(T.self, from: jsonData) else { return nil }
        return model
    }
}
