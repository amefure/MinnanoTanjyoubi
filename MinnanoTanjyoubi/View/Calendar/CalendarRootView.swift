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
            YearAndMonthSelectionView()
                .environmentObject(viewModel)
                .environmentObject(rootEnvironment)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(week.color ?? rootEnvironment.scheme.text)
                }
            }.padding(.vertical, 8)
                .frame(height: 40)

            CarouselCalendarView()
                .environmentObject(viewModel)

            Spacer()

        }.navigationBarBackButtonHidden()
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .frame(width: DeviceSizeUtility.deviceWidth)
            .background(rootEnvironment.scheme.foundationSub)
    }
}

#Preview {
    CalendarRootView(users: [])
        .environmentObject(RootEnvironment.shared)
}
