//
//  ImageFileManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import UIKit

/// アプリからデバイス内(Docmentsフォルダ)へ画像を保存するクラス
final class ImageFileManager: Sendable {
    private let suffix = ".jpg"

    /// DocmentsフォルダまでのURLを取得
    /// file:///var/mobile/Containers/Data/Application/085DB140-E500-4561-8EA3-A6AF0748AD27/Documents
    /// ↑ 形式で取得できるが`Application/UUID`の`UUID部分はアップデートなどで変わってしまう`ことがあるので
    /// このパスを保存して使用するみたいなことはできないので注意
    private func getDocmentsUrl(_ fileName: String) -> URL? {
        let fileManager = FileManager.default
        do {
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            // URLを構築
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        } catch {
            AppLogger.logger.debug("ドキュメントパスの取得失敗")
            return nil
        }
    }

    public func loadImage(name: String) -> UIImage? {
        /// 名前がないなら終了
        guard name != "" else { return nil }

        guard let path = getDocmentsUrl("\(name + suffix)")?.path else { return nil }
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return image
    }

    public func loadImagePath(name: String) -> String? {
        /// 名前がないなら終了
        guard name != "" else { return nil }

        guard let path = getDocmentsUrl("\(name + suffix)")?.path else { return nil }
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard UIImage(contentsOfFile: path) != nil else { return nil }
        return path
    }

    /// 画像保存処理
    public func saveImage(name: String, image: UIImage) throws -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { throw ImageError.castFailed }
        guard let path = getDocmentsUrl("\(name + suffix)") else { throw ImageError.castFailed }
        do {
            try imageData.write(to: path)
            return true
        } catch {
            throw ImageError.saveFailed
        }
    }

    /// 画像削除処理
    public func deleteImage(name: String) throws -> Bool {
        guard let path = getDocmentsUrl("\(name + suffix)") else { throw ImageError.castFailed }
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: path)
            return true
        } catch {
            throw ImageError.deleteFailed
        }
    }
}
