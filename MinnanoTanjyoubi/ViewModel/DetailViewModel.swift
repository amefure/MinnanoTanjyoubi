//
//  DetailViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import SwiftUI
import UIKit

class DetailViewModel: ObservableObject {
    /// 保存成功ダイアログ
    @Published var isSaveSuccessAlert: Bool = false
    /// 削除確認ダイアログ
    @Published var isDeleteConfirmAlert: Bool = false
    /// 削除成功ダイアログ
    @Published var isDeleteSuccessAlert: Bool = false
    /// 画像表示ダイアログ
    @Published var isImageShowAlert: Bool = false
    /// 画像エラーダイアログ
    @Published var isImageErrorAlert: Bool = false

    /// 削除対象のパス
    @Published private(set) var isUpdateView: Int = 0
    /// 画像エラー
    @Published private(set) var imageError: ImageError?

    /// 削除対象のパス
    public var selectPath: String = ""
    /// 表示対象のUIImage
    public var selectImage: Image?

    /// ImageContainerViewの描画更新フラグ
    public func updateView() {
        isUpdateView += 1
    }

    /// エラーハンドラー
    public func showImageErrorHandle(error: ImageError) {
        imageError = error
        isImageErrorAlert = true
    }
}
