//
//  RemoveButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import RealmSwift
import SwiftUI

struct RemoveButtonView: View {
    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // MARK: - View

    @State private var isAlert: Bool = false

    // MARK: - Environment

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        Button(action: {
            if rootEnvironment.deleteIdArray.count != 0 {
                isAlert = true
            } else {
                if rootEnvironment.isDeleteMode {
                    rootEnvironment.disableDeleteMode()
                } else {
                    rootEnvironment.enableDeleteMode()
                }
            }
        }, label: {
            Image(systemName: rootEnvironment.isDeleteMode ? "trash" : "app.badge.checkmark")
        }).circleBorderView(width: 50, height: 50, color: ColorAsset.themaColor2.thisColor)
            .alert("選択したユーザーを\n削除しますか？", isPresented: $isAlert) {
                Button(role: .destructive, action: {
                    repository.removeUser(removeIdArray: rootEnvironment.deleteIdArray)
                    rootEnvironment.resetDeleteMode()
                }, label: {
                    Text("削除")
                })
                Button(role: .cancel, action: {
                    rootEnvironment.resetDeleteMode()
                }, label: {
                    Text("キャンセル")
                })
            } message: {
                Text("")
            }
    }
}
