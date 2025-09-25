//
//  YearPickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import SwiftUI

struct YearPickerView: View {
    @StateObject var viewModel: SettingViewModel
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var year: Int = 2025

    var body: some View {
        Picker("登録年数初期値", selection: $year) {
            ForEach(viewModel.yearArray, id: \.self) { year in
                Text("\(String(year))年")
                    .fontM()
            }
        }.tint(AppColorScheme.getText(rootEnvironment.scheme))
            .fontM()
            .onChange(of: year) { _ in
                viewModel.registerEntryInitYear(year: year)
            }.onAppear {
                year = viewModel.getEntryInitYear()
            }
    }
}

#Preview {
    YearPickerView(viewModel: SettingViewModel())
}
