//
//  YearAndMonthSelectionView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some View {
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
}

#Preview {
    YearAndMonthSelectionView()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
