//
//  RemoveButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import RealmSwift
import SwiftUI

struct RemoveButtonView: View {
    // MARK: - Controller

    private let realmCrudManager = RealmCrudManager()

    // MARK: - View

    @State var isAlert: Bool = false

    @Binding var isDeleteMode: Bool
    @Binding var deleteIdArray: [ObjectId]

    var body: some View {
        Button(action: {
            if deleteIdArray.count != 0 {
                isAlert = true
            } else {
                isDeleteMode.toggle()
            }
        }, label: {
            Image(systemName: isDeleteMode ? "trash" : "app.badge.checkmark")
        }).circleBorderView(width: 50, height: 50, color: ColorAsset.themaColor2.thisColor)

            .alert("選択したユーザーを\n削除しますか？", isPresented: $isAlert) {
                Button(role: .destructive, action: {
                    realmCrudManager.removeUser(removeIdArray: deleteIdArray)
                    deleteIdArray = []
                    isDeleteMode = false
                }, label: {
                    Text("削除")
                })
                Button(role: .cancel, action: {
                    deleteIdArray = []
                    isDeleteMode = false
                }, label: {
                    Text("キャンセル")
                })
            } message: {
                Text("")
            }
    }
}
