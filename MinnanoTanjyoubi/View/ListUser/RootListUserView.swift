//
//  RootListUserView.swift
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

    private func noDataView() -> some View {
        VStack {
            Spacer()

            Text("登録されている誕生日情報がありません。")
                .fontM(bold: true)
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))

            Spacer()
        }
    }

    /// iOS18かどうか
    private var isIos18: Bool {
        if #available(iOS 18, *) {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            switch rootEnvironment.sectionLayoutFlag {
            case .calendar:
                // 単体のグリッドレイアウト
                CalendarRootView(users: repository.users)
                    .environmentObject(rootEnvironment)

            default:
                ZStack {
                    // List Contents
                    if repository.users.count == 0 {
                        noDataView()
                    } else {
                        ScrollView {
                            Group {
                                switch rootEnvironment.sectionLayoutFlag {
                                case .grid:
                                    // 単体のグリッドレイアウト
                                    SingleGridListView(users: repository.users)
                                        .environmentObject(rootEnvironment)
                                case .group:
                                    // カテゴリセクショングリッドレイアウト
                                    SectionGridListView()
                                        .environmentObject(rootEnvironment)
                                case .calendar:
                                    // ここは呼ばれない
                                    EmptyView()
                                }
                            }.padding(.bottom, 75)
                                .simultaneousGesture(drag)
                        }.padding([.top, .trailing, .leading])
                            .if(isIos18) { view in
                                // FIXME: - iOS17以前ではスクロールが動作しないため暫定対応としてiOS18以降のみ
                                view
                                    .simultaneousGesture(drag)
                            }
                    }

                    VStack {
                        Spacer()

                        ControlPanelView(
                            isScrollingDown: $isScrollingDown
                        ).environmentObject(rootEnvironment)
                            .opacity(opacity)
                    }.onTapGesture {
                        opacity = 1
                    }
                }
            }

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .onChange(of: isScrollingDown) { _ in
                // 下方向にスクロール中のみ半透明にする
                opacity = isScrollingDown ? 0.5 : 1
            }
    }
}
