//
//  CalendarRootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SCCalendar
import SwiftUI

struct CalendarRootView: View {
    @State private var viewModel = DIContainer.shared.resolve(CalendarViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment

    private let weekColumns = Array(repeating: GridItem(spacing: 0), count: 7)

    @State private var selectTheDay: SCDate = .demo
    /// 上限に達した場合のアラート
    @State private var isLimitAlert: Bool = false
    /// 新規登録モーダル表示
    @State private var isShowEntryModal: Bool = false
    /// 複数誕生日リストモーダル表示
    @State private var isShowMulchModal: Bool = false
    /// 詳細画面表示
    @State private var isShowDetailView: Bool = false
    /// 複数存在時に詳細画面に遷移するUser情報を保持する
    @State private var user: User?

    var body: some View {
        VStack(spacing: 0) {
            yearAndMonthSelectionView()

            dayOfWeekListView()

            CarouselCalendarView(
                yearAndMonths: viewModel.state.yearAndMonths,
                displayCalendarIndex: viewModel.state.displayCalendarIndex,
                backMonthPage: viewModel.backMonthPage,
                forwardMonthPage: viewModel.forwardMonthPage,
                scheme: rootEnvironment.state.scheme,
                onTapDay: { theDay in
                    selectTheDay = theDay
                    if theDay.users.isEmpty {
                        // 0なら新規登録
                        // 容量がオーバーしていないか または 容量解放されている
                        if !viewModel.isOverCapacity(1) || rootEnvironment.state.unlockStorage {
                            // 登録モーダル表示
                            isShowEntryModal.toggle()
                        } else {
                            // 容量オーバーアラート表示
                            isLimitAlert = true
                        }
                    } else if theDay.users.count == 1 {
                        // 1なら詳細画面へ遷移
                        isShowDetailView = true
                    } else if theDay.users.count >= 2 {
                        // 2以上ならリスト表示
                        isShowMulchModal = true
                    }
                }
            )

            Spacer()

        }.navigationBarBackButtonHidden()
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .frame(width: DeviceSizeUtility.deviceWidth)
            .background(rootEnvironment.state.scheme.foundationSub)
            .if(selectTheDay.users.isEmpty) { view in
                view
                    .sheet(isPresented: $isShowEntryModal) {
                        EntryUserView(
                            updateUserId: nil,
                            isCalendarMonth: selectTheDay.month,
                            isCalendarDay: selectTheDay.day,
                            isSelfShowModal: $isShowEntryModal
                        )
                    }.alert(
                        isPresented: $isLimitAlert,
                        title: "Error...",
                        message: "保存容量が上限に達しました。\n設定から広告を視聴すると\n保存容量を増やすことができます。",
                        positiveButtonTitle: "OK",
                        positiveAction: {
                            isLimitAlert = false
                        }
                    )
            }.if(selectTheDay.users.count == 1) { view in
                view
                    .navigationDestination(isPresented: $isShowDetailView) {
                        DetailUserView(userId: selectTheDay.users.first!.id)
                    }
            }.if(selectTheDay.users.count >= 2) { view in
                view
                    .sheet(isPresented: $isShowMulchModal) {
                        mulchUserSelectListView()
                    }.navigationDestination(isPresented: $isShowDetailView) {
                        if let user {
                            DetailUserView(userId: user.id)
                        }
                    }
            }
    }

    /// 年月選択ヘッダービュー
    private func yearAndMonthSelectionView() -> some View {
        HStack {
            Spacer()

            Button {
                viewModel.backMonthPage()
            } label: {
                Image(systemName: "chevron.backward")
            }.frame(width: 10)

            Button {
                viewModel.moveTodayCalendar()
            } label: {
                Text(viewModel.getCurrentYearAndMonth().yearAndMonth)
                    .fontM(bold: true)
                    .frame(width: 100)
            }.frame(width: 100)
                .padding()

            Button {
                viewModel.forwardMonthPage()
            } label: {
                Image(systemName: "chevron.forward")
            }.frame(width: 10)

            Spacer()

        }.foregroundStyle(rootEnvironment.state.scheme.text)
    }

    /// 曜日リスト
    private func dayOfWeekListView() -> some View {
        LazyVGrid(columns: weekColumns, spacing: 0) {
            ForEach(viewModel.state.dayOfWeekList, id: \.self) { week in
                Text(week.shortSymbols)
                    .foregroundStyle(week.color ?? rootEnvironment.state.scheme.text)
            }
        }.padding(.vertical, 8)
            .frame(height: 40)
    }

    /// 複数のユーザーが紐づいている場合専用のリスト表示ビュー
    private func mulchUserSelectListView() -> some View {
        VStack(spacing: 0) {
            Text(selectTheDay.getDate())
                .fontM(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectTheDay.users) { user in
                        Button {
                            isShowMulchModal = false
                            self.user = user
                            isShowDetailView = true
                        } label: {
                            RowUserView(user: user)
                                .frame(width: CGFloat(DeviceSizeUtility.deviceWidth / 3) - 10)
                        }.buttonStyle(.plain)
                    }
                }
            }.padding(.vertical)
        }.presentationDetents([.height(200)])
            .padding()
            .ignoresSafeArea(.all)
            .background(rootEnvironment.state.scheme.foundationSub)
    }
}

#Preview {
    CalendarRootView()
}
