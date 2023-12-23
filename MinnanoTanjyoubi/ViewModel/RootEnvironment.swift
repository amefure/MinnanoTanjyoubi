//
//  RootEnvironment.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import Combine
import RealmSwift
import UIKit

/// アプリ内で共通で利用される状態や環境値を保持する
class RootEnvironment: ObservableObject {
    // Deleteモード
    @Published private(set) var isDeleteMode: Bool = false
    // 削除対象のUserId
    @Published var deleteIdArray: [ObjectId] = []

//    // エラーダイアログ表示
//    @Published var isPresentError: Bool = false
//    // エラーダイアログタイトル
//    @Published private(set) var errorTitle: String = ""
//    // エラーダイアログメッセージ
//    @Published private(set) var errorMessage: String = ""

    private var cancellables: Set<AnyCancellable> = []

    // エラービュー表示
//    public func presentErrorView(error: AliveError) {
//        isPresentError = true
//        errorTitle = error.title
//        errorMessage = error.message
//    }
//

    /// Deleteモード有効
    public func enableDeleteMode() {
        isDeleteMode = true
    }

    /// Deleteモード無効
    public func disableDeleteMode() {
        isDeleteMode = false
    }

    /// 対象のUserIdを追加
    public func appendDeleteIdArray(id: ObjectId) {
        deleteIdArray.append(id)
    }

    /// 対象のUserIdを削除
    public func removeDeleteIdArray(id: ObjectId) {
        if let index = deleteIdArray.firstIndex(of: id) {
            deleteIdArray.remove(at: index)
        }
    }

    /// Deleteモードリセット
    public func resetDeleteMode() {
        isDeleteMode = false
        deleteIdArray.removeAll()
    }
}
