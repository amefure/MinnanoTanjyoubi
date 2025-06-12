//
//  ImageFileManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import SwiftUI
import UIKit

/// アプリからデバイス内(Docmentsフォルダ)へ画像を保存するクラス
class ImageFileManager {
    private var fileManager = FileManager.default

    private var suffix = ".jpg"

    // DocmentsフォルダまでのURLを取得
    private func getDocmentsUrl(_ fileName: String) -> URL? {
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
            return nil
        }
    }

    public func loadImage(name: String) -> UIImage? {
        /// 名前がないなら終了
        guard name != "" else { return nil }

        guard let path = getDocmentsUrl("\(name + suffix)")?.path else { return nil }

        if fileManager.fileExists(atPath: path) {
            if let image = UIImage(contentsOfFile: path) {
                return image
            } else {
                return nil
            }
        }
        return nil
    }

    public func loadImagePath(name: String) -> String? {
        /// 名前がないなら終了
        guard name != "" else { return nil }

        guard let path = getDocmentsUrl("\(name + suffix)")?.path else { return nil }

        if fileManager.fileExists(atPath: path) {
            if UIImage(contentsOfFile: path) != nil {
                return path
            } else {
                return nil
            }
        }
        return nil
    }

    /// 画像保存処理
    public func saveImage(name: String, image: UIImage) -> AnyPublisher<Void, ImageError> {
        Deferred {
            Future<Void, ImageError> { [weak self] promise in
                guard let self = self else { return promise(.failure(.castFailed)) }
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return promise(.failure(.castFailed)) }
                guard let path = self.getDocmentsUrl("\(name + self.suffix)") else { return promise(.failure(.castFailed)) }
                do {
                    try imageData.write(to: path)
                    promise(.success(()))
                } catch {
                    promise(.failure(.saveFailed))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// 画像削除処理
    public func deleteImage(name: String) -> AnyPublisher<Void, ImageError> {
        Deferred {
            Future<Void, ImageError> { [weak self] promise in
                guard let self = self else { return promise(.failure(.castFailed)) }

                guard let path = self.getDocmentsUrl("\(name + self.suffix)") else { return promise(.failure(.castFailed)) }
                do {
                    try fileManager.removeItem(at: path)
                    promise(.success(()))
                } catch {
                    promise(.failure(.deleteFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
}
