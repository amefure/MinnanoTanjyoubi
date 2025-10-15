//
//  RootListUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI
import UIKit

/// データをグリッドレイアウト・セクションレイアウト・カレンダー表示を切り替え
struct RootListUserView: View {
    
    @StateObject private var viewModel = RootListUserViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @GestureState private var dragOffset = CGSize.zero

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .updating($dragOffset, body: { value, state, _ in
                state = value.translation
                if value.translation.height < 0 {
                    /// iOS17以前で
                    /// ‘Modifying state during view update, this will cause undefined behavior‘
                    viewModel.isScrollingDown = true
                } else if value.translation.height > 0 {
                    viewModel.isScrollingDown = false
                }
            })
            .onEnded { value in
                if value.translation.height < 0 {
                    viewModel.isScrollingDown = true
                } else {
                    viewModel.isScrollingDown = false
                }
            }
    }

    private func noDataView() -> some View {
        VStack {
            Spacer()

            Text("登録されている誕生日情報がありません。")
                .fontM(bold: true)
                .foregroundStyle(rootEnvironment.scheme.text)

            Spacer()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            switch rootEnvironment.sectionLayoutFlag {
            case .calendar:
                // 単体のグリッドレイアウト
                CalendarRootView()
                    .environmentObject(rootEnvironment)

            default:
                ZStack {
                    // List Contents
                    if viewModel.allUsers.isEmpty {
                        noDataView()
                    } else {
                        ScrollView {
                            Group {
                                switch rootEnvironment.sectionLayoutFlag {
                                case .grid:
                                    // 単体のグリッドレイアウト
                                    SingleGridListView(users: viewModel.allUsers)
                                        .environmentObject(rootEnvironment)
                                case .group:
                                    // カテゴリセクショングリッドレイアウト
                                    SectionGridListView(users: viewModel.allUsers)
                                        .environmentObject(rootEnvironment)
                                case .calendar:
                                    // ここは呼ばれない
                                    EmptyView()
                                }
                            }.padding(.bottom, 75)
                        }.padding([.top, .trailing, .leading])
                            .if(viewModel.isIos18Later) { view in
                                // FIXME: - iOS17以前ではスクロールが動作しないため暫定対応としてiOS18以降のみ
                                view
                                    .simultaneousGesture(drag)
                            }
                    }

                    VStack {
                        Spacer()

                        controlPanelView()
                            .opacity(viewModel.opacity)
                    }.onTapGesture {
                        viewModel.opacity = 1
                    }
                }
            }

        }.background(rootEnvironment.scheme.foundationSub)
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
           
    }
    

    /// フッターコントロールパネル
    private func controlPanelView() -> some View {
        HStack {
            let tapGesture = TapGesture()
                .onEnded { viewModel.isScrollingDown = false }
            Spacer()

            RemoveButtonView()
                .environmentObject(rootEnvironment)
                .simultaneousGesture(tapGesture)

            Spacer()

            SortedButtonView()
                .environmentObject(rootEnvironment)
                .simultaneousGesture(tapGesture)

            Spacer()

            entryButtonView()
                .simultaneousGesture(tapGesture)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            .foregroundStyle(rootEnvironment.scheme.controlText)
            .background(rootEnvironment.scheme.foundationPrimary)
    }

    
    private func entryButtonView() -> some View {
        Button {
            viewModel.checkEntryEnabled()
        } label: {
            Image(systemName: "plus")
                .fontM()
        }.circleBorderView(width: 50, height: 50, color: rootEnvironment.scheme.thema3)
            .sheet(isPresented: $viewModel.isShowEntryModal) {
                EntryUserView(updateUserId: nil, isSelfShowModal: $viewModel.isShowEntryModal)
                    .environmentObject(rootEnvironment)
            }.alert(
                isPresented: $viewModel.isShowLimitAlert,
                title: "Error...",
                message: "保存容量が上限に達しました。\n設定から広告を視聴すると\n保存容量を増やすことができます。",
                positiveButtonTitle: "OK"
            )
    }
}
