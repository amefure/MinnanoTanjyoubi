//
//  CalendarRootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct CalendarRootView: View {
    public var users: [User]
    @StateObject private var viewModel = CalendarViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            // Viewの読み込みが完了するまで待機する
            if viewModel.currentDates.count == 0 {
                Spacer()
                    .frame(width: DeviceSizeUtility.deviceWidth)

                // .overlayLoadingDialog()によりローディングビューが表示される

                Spacer()

            } else {
                YearAndMonthSelectionView()
                    .environmentObject(viewModel)
                    .environmentObject(rootEnvironment)

                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(viewModel.dayOfWeekList, id: \.self) { week in
                        Text(week.shortSymbols)
                            .foregroundStyle(week.color ?? AppColorScheme.getText(rootEnvironment.scheme))
                    }
                }.padding(.vertical, 8)

                CarouselCalendarView()
                    .environmentObject(viewModel)

                Spacer()
            }

        }.navigationBarBackButtonHidden()
            .onAppear { viewModel.onAppear(users: users) }
            .onDisappear { viewModel.onDisappear() }
            .frame(width: DeviceSizeUtility.deviceWidth)
            .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
    }
}

#Preview {
    CalendarRootView(users: [])
        .environmentObject(RootEnvironment.shared)
}
