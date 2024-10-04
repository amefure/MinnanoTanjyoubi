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

    @State private var isScrollingDown = false
    @GestureState private var dragOffset = CGSize.zero
    @State private var opacity: Double = 1

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .updating($dragOffset, body: { value, state, _ in
                state = value.translation
                if value.translation.height < 0 {
                    /// iOS17以前で
                    /// ‘Modifying state during view update, this will cause undefined behavior‘
                    isScrollingDown = true
                } else if value.translation.height > 0 {
                    isScrollingDown = false
                }
            })
            .onEnded { value in
                if value.translation.height < 0 {
                    isScrollingDown = true
                } else {
                    isScrollingDown = false
                }
            }
    }

    var body: some View {
        VStack(spacing: 0) {
            if #available(iOS 18, *) {
                ZStack {
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
                            Group {
                                if rootEnvironment.sectionLayoutFlag {
                                    // カテゴリセクショングリッドレイアウト
                                    SectionGridListView()
                                        .environmentObject(rootEnvironment)
                                } else {
                                    // 単体のグリッドレイアウト
                                    SingleGridListView(users: repository.users)
                                        .environmentObject(rootEnvironment)
                                }
                            }.padding(.bottom, 75)
                                .simultaneousGesture(drag)
                        }.padding([.top, .trailing, .leading])
                            .simultaneousGesture(drag)
                    }

                    VStack {
                        Spacer()

                        ControlPanelView(
                            isDeleteAlert: $isDeleteAlert,
                            isLimitAlert: $isLimitAlert,
                            isScrollingDown: $isScrollingDown
                        ).environmentObject(rootEnvironment)
                            .opacity(opacity)
                    }.onTapGesture {
                        opacity = 1
                    }
                }
            } else {
                // FIXME: - iOS17以前ではスクロールが動作しないため暫定対応
                VStack {
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
                            Group {
                                if rootEnvironment.sectionLayoutFlag {
                                    // カテゴリセクショングリッドレイアウト
                                    SectionGridListView()
                                        .environmentObject(rootEnvironment)
                                } else {
                                    // 単体のグリッドレイアウト
                                    SingleGridListView(users: repository.users)
                                        .environmentObject(rootEnvironment)
                                }
                            }.padding(.bottom, 75)
                        }.padding([.top, .trailing, .leading])
                    }

                    ControlPanelView(
                        isDeleteAlert: $isDeleteAlert,
                        isLimitAlert: $isLimitAlert,
                        isScrollingDown: $isScrollingDown
                    ).environmentObject(rootEnvironment)
                }
            }

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .onChange(of: isScrollingDown) { _ in
                // 下方向にスクロール中のみ半透明にする
                opacity = isScrollingDown ? 0.5 : 1
            }
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
