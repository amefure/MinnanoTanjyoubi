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
                        .foregroundStyle(week.color ?? AppColorScheme.getText(rootEnvironment.scheme))
                }
            }.padding(.vertical, 8)
                .frame(height: 40)

            CarouselCalendarView()
                .environmentObject(viewModel)

            Spacer()

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
