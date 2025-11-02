//
//  CalendarRootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct CalendarRootView: View {
    @State private var viewModel = DIContainer.shared.resolve(CalendarViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment

    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            yearAndMonthSelectionView()

            dayOfWeekListView()

            CarouselCalendarView(viewModel: viewModel)

            Spacer()

        }.navigationBarBackButtonHidden()
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .frame(width: DeviceSizeUtility.deviceWidth)
            .background(rootEnvironment.state.scheme.foundationSub)
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
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.state.dayOfWeekList, id: \.self) { week in
                Text(week.shortSymbols)
                    .foregroundStyle(week.color ?? rootEnvironment.state.scheme.text)
            }
        }.padding(.vertical, 8)
            .frame(height: 40)
    }
}

#Preview {
    CalendarRootView()
}
