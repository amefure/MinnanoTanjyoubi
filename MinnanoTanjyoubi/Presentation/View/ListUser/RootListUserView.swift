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
    @StateObject private var viewModel = DIContainer.shared.resolve(RootListUserViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @GestureState private var dragOffset = CGSize.zero

    /// 新規登録モーダル表示
    @State private var isShowEntryModal: Bool = false

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
                .foregroundStyle(rootEnvironment.state.scheme.text)

            Spacer()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            switch rootEnvironment.state.sectionLayoutFlag {
            case .calendar:
                // カレンダーレイアウト
                CalendarRootView()

            default:
                ZStack {
                    // List Contents
                    if viewModel.allUsers.isEmpty {
                        noDataView()
                    } else {
                        ScrollView {
                            Group {
                                switch rootEnvironment.state.sectionLayoutFlag {
                                case .grid:
                                    // 単体のグリッドレイアウト
                                    SingleGridListView(users: viewModel.allUsers)
                                case .group:
                                    // カテゴリセクショングリッドレイアウト
                                    SectionGridListView(users: viewModel.allUsers)
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

        }.background(rootEnvironment.state.scheme.foundationSub)
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
    }

    /// フッターコントロールパネル
    private func controlPanelView() -> some View {
        HStack {
            let tapGesture = TapGesture()
                .onEnded { viewModel.isScrollingDown = false }
            Spacer()

            removeButtonView()
                .circleBorderView(width: 50, height: 50, color: rootEnvironment.state.scheme.thema2)
                .simultaneousGesture(tapGesture)

            Spacer()

            filteringButtonView()
                .circleBorderView(width: 50, height: 50, color: rootEnvironment.state.scheme.thema4)
                .simultaneousGesture(tapGesture)

            Spacer()

            entryButtonView()
                .circleBorderView(width: 50, height: 50, color: rootEnvironment.state.scheme.thema3)
                .simultaneousGesture(tapGesture)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            .foregroundStyle(rootEnvironment.state.scheme.controlText)
            .background(rootEnvironment.state.scheme.foundationPrimary)
    }

    private func removeButtonView() -> some View {
        Button {
            if !rootEnvironment.state.deleteArray.isEmpty {
                viewModel.isDeleteConfirmAlert = true
            } else {
                if rootEnvironment.state.isDeleteMode {
                    rootEnvironment.disableDeleteMode()
                } else {
                    rootEnvironment.enableDeleteMode()
                }
            }
        } label: {
            Image(systemName: rootEnvironment.state.isDeleteMode ? "trash" : "app.badge.checkmark")
                .fontM()
        }.alert(
            isPresented: $viewModel.isDeleteConfirmAlert,
            title: "お知らせ",
            message: "選択した誕生日情報を\n削除しますか？",
            positiveButtonTitle: "削除",
            negativeButtonTitle: "キャンセル",
            positiveButtonRole: .destructive,
            positiveAction: {
                viewModel.removeUsers(users: rootEnvironment.state.deleteArray)
                rootEnvironment.resetDeleteMode()
            },
            negativeAction: {
                rootEnvironment.resetDeleteMode()
            }
        )
    }

    private func filteringButtonView() -> some View {
        Button {
            viewModel.showSortPickerOrResetFiltering()
        } label: {
            Image(systemName: viewModel.isFiltering ? "arrowshape.turn.up.backward.fill" : "person.2.crop.square.stack")
                .fontM()
        }.sheet(isPresented: $viewModel.isShowRelationPicker) {
            VStack {
                Picker(selection: $viewModel.selectedFilteringRelation) {
                    ForEach(Array(rootEnvironment.state.relationNameList.enumerated()), id: \.element) { index, item in
                        Text(item).tag(Relation.getIndexbyRelation(index))
                    }
                } label: {}
                    .pickerStyle(.segmented)
                    .presentationDetents([.height(100)])
            }
        }
    }

    private func entryButtonView() -> some View {
        Button {
            viewModel.checkEntryEnabled()
        } label: {
            Image(systemName: "plus")
                .fontM()
        }.sheet(isPresented: $viewModel.isShowEntryModal) {
            EntryUserView(updateUserId: nil)
        }.alert(
            isPresented: $viewModel.isShowLimitAlert,
            title: "Error...",
            message: "保存容量が上限に達しました。\n設定から広告を視聴すると\n保存容量を増やすことができます。",
            positiveButtonTitle: "OK"
        )
    }
}
