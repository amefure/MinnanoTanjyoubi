//
//  CryptoUtillity.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import CryptoSwift
import UIKit

/// 暗号化/複合化クラス
class CryptoUtillity {
    /// 文字列を暗号化して返却
    /// - Parameter targetText: 暗号化対象の文字列
    /// - Returns: 暗号化文字列
    public func encryption(_ targetText: String) -> String? {
        do {
            // AESキーと初期ベクトルを使用してAESインスタンスを生成
            let aes = try AES(key: SecretCryptoKey.KEY, iv: SecretCryptoKey.IV)
            // 渡された文字列をUTF-8のバイト配列に変換し、AESで暗号化
            let encrypted = try aes.encrypt(Array(targetText.utf8))

            // 暗号化されたデータをData型に変換
            let data = Data(encrypted)

            // Data型をBase64エンコード
            let base64Data: Data = data.base64EncodedData() as Data

            // Base64エンコードされたData型をUTF-8文字列に変換
            guard let base64Str = String(data: base64Data, encoding: String.Encoding.utf8) else { return nil }

            return base64Str
        } catch {
            return nil
        }
    }

    /// 暗号化された文字列を複合化して返却
    /// - Parameter cipherText: 暗号化された文字列
    /// - Returns: 複合化して平分にした文字列
    public func decryption(_ cipherText: String) -> String? {
        do {
            // AESキーと初期ベクトルを使用してAESインスタンスを生成
            let aes = try AES(key: SecretCryptoKey.KEY, iv: SecretCryptoKey.IV)
            // 文字列をUTF-8エンコーディングしてバイトデータに変換
            guard let byteData = cipherText.data(using: String.Encoding.utf8) else { return nil }
            // Base64データをデコードして元のデータに戻す
            guard let data = Data(base64Encoded: byteData) else { return nil }

            // データをUInt8の配列に変換
            let aBuffer = [UInt8](data)
            // AESで復号化
            let decrypted = try aes.decrypt(aBuffer)

            // 復号化されたデータをUTF-8文字列に変換
            guard let decryptedStr = String(data: Data(decrypted), encoding: .utf8) else { return nil }
            // 結果を返す
            return decryptedStr
        } catch {
            // エラー処理
            return nil
        }
    }
}
