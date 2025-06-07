//
//  CalendarRootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct CalendarRootView: View {
    @ObservedObject private var viewModel = CalendarViewModel()

    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)

    @State private var msg = ""

    var body: some View {
        VStack(spacing: 0) {
            YearAndMonthSelectionView()

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(AppColorScheme.getThema1(.dark))
                        .opacity(0.8)
                }
            }

            CarouselCalendarView()

            Spacer()
        }
    }
}

#Preview {
    CalendarRootView()
}
