//
//  ListUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI
import UIKit

/// データをリスト表示するビュー
struct RootListUserView: View {
    // Models
    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isDeleteAlert = false
    @State private var isLimitAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // List Contents
            if repository.users.count == 0 {
                Spacer()

                Text("登録されている誕生日情報がありません。")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))

                Spacer()

            } else {
                ScrollView {
                    if rootEnvironment.sectionLayoutFlag {
                        // カテゴリセクショングリッドレイアウト
                        SectionGridListView()
                            .environmentObject(rootEnvironment)
                    } else {
                        // 単体のグリッドレイアウト
                        SingleGridListView(users: repository.users)
                            .environmentObject(rootEnvironment)
                    }
                }.padding([.top, .trailing, .leading])
            }

            // ControlPanel
            ControlPanelView(isDeleteAlert: $isDeleteAlert, isLimitAlert: $isLimitAlert)
                .environmentObject(rootEnvironment)

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .dialog(
                isPresented: $isDeleteAlert,
                title: "お知らせ",
                message: "選択した誕生日情報を\n削除しますか？",
                positiveButtonTitle: "削除",
                negativeButtonTitle: "キャンセル",
                positiveAction: {
                    repository.removeUser(removeIdArray: rootEnvironment.deleteIdArray)
                    rootEnvironment.resetDeleteMode()
                },
                negativeAction: {
                    rootEnvironment.resetDeleteMode()
                }
            )
            .dialog(
                isPresented: $isLimitAlert,
                title: "お知らせ",
                message: "保存容量が上限に達しました...\n設定から広告を視聴すると\n保存容量を増やすことができます。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    isLimitAlert = false
                },
                negativeAction: {}
            )
    }
}
