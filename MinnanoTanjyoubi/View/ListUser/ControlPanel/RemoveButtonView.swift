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

    @State private var isDeleteAlert: Bool = false
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        Button {
            if !rootEnvironment.deleteArray.isEmpty {
                isDeleteAlert = true
            } else {
                if rootEnvironment.isDeleteMode {
                    rootEnvironment.disableDeleteMode()
                } else {
                    rootEnvironment.enableDeleteMode()
                }
            }
        } label: {
            Image(systemName: rootEnvironment.isDeleteMode ? "trash" : "app.badge.checkmark")
                .font(.system(size: 17))
        }.circleBorderView(width: 50, height: 50, color: AppColorScheme.getThema2(rootEnvironment.scheme))
            .alert(
                isPresented: $isDeleteAlert,
                title: "お知らせ",
                message: "選択した誕生日情報を\n削除しますか？",
                positiveButtonTitle: "削除",
                negativeButtonTitle: "キャンセル",
                positiveButtonRole: .destructive,
                positiveAction: {
                    repository.removeUsers(users: rootEnvironment.deleteArray)
                    rootEnvironment.resetDeleteMode()
                },
                negativeAction: {
                    rootEnvironment.resetDeleteMode()
                }
            )
    }
}

#Preview {
    RemoveButtonView()
        .environmentObject(RootEnvironment())
}
