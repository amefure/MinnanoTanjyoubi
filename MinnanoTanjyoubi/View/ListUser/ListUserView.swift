//
//  ListUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI
import UIKit

// MARK: - データをリスト表示するビュー

struct ListUserView: View {
    // MARK: - Models

    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    @State private var isDeleteAlert = false
    @State private var isLimitAlert = false

    // MARK: - Glid Layout

    private var gridItemWidth: CGFloat {
        return CGFloat(DeviceSizeManager.deviceWidth / 3) - 10
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth)), count: 3)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - List Contents

            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(repository.users) { user in
                        if rootEnvironment.isDeleteMode {
                            // DeleteMode
                            CheckRowUserView(user: user)
                        } else {
                            // NormalMode
                            NavigationLink {
                                DetailUserView(user: user)
                            } label: {
                                RowUserView(user: user)
                            }
                        }
                    }
                }
            }.padding([.top, .trailing, .leading])

            // MARK: - ControlPanel

            ControlPanelView(isDeleteAlert: $isDeleteAlert, isLimitAlert: $isLimitAlert)

        }.background(ColorAsset.foundationColorLight.thisColor)
            .dialog(
                isPresented: $isDeleteAlert,
                title: "お知らせ",
                message: "選択したユーザーを\n削除しますか？",
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
