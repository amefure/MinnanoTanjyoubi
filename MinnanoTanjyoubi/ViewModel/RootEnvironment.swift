//
//  RootEnvironment.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import Combine
import RealmSwift
import UIKit

class RootEnvironment: ObservableObject {
    // Deleteモード
    @Published private(set) var isDeleteMode: Bool = false
    // 削除対象のUserId
    @Published var deleteIdArray: [ObjectId] = []

    // エラーダイアログ表示
    @Published var isPresentError: Bool = false
    // エラーダイアログタイトル
    @Published private(set) var errorTitle: String = ""
    // エラーダイアログメッセージ
    @Published private(set) var errorMessage: String = ""

    private var cancellables: Set<AnyCancellable> = []

    // エラービュー表示
//    public func presentErrorView(error: AliveError) {
//        isPresentError = true
//        errorTitle = error.title
//        errorMessage = error.message
//    }
//

    // Deleteモード有効
    public func enableDeleteMode() {
        isDeleteMode = true
    }

    // Deleteモード無効
    public func disableDeleteMode() {
        isDeleteMode = false
    }

    public func appendDeleteIdArray(id: ObjectId) {
        deleteIdArray.append(id)
    }

    public func removeDeleteIdArray(id: ObjectId) {
        if let index = deleteIdArray.firstIndex(of: id) {
            deleteIdArray.remove(at: index)
        }
    }

    public func resetDeleteMode() {
        isDeleteMode = false
        deleteIdArray.removeAll()
    }
}
