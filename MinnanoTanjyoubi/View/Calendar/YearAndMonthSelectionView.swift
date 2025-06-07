//
//  YearAndMonthSelectionView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    public var showBackButton = false

    @EnvironmentObject private var viewModel: CalendarViewModel

    @State private var showChart = false
    @State private var showSetting = false

    // MARK: - Environment

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer()
                .frame(width: 30)
                .padding(.horizontal, 10)

            Button {
                viewModel.backMonthPage()
            } label: {
                Image(systemName: "chevron.backward")
            }.frame(width: 10)

            Spacer()

            NavigationLink {} label: {
                Text(viewModel.getCurrentYearAndMonth().yearAndMonth)
                    .frame(width: 100)
                    .fontWeight(.bold)
            }.frame(width: 100)

            Spacer()

            Button {
                viewModel.forwardMonthPage()
            } label: {
                Image(systemName: "chevron.forward")
            }.frame(width: 10)

            Button {
                viewModel.moveTodayCalendar()
            } label: {
                Image("back_today")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }.padding(.horizontal, 10)
                .frame(width: 30)
        }
    }
}

#Preview {
    YearAndMonthSelectionView()
}
