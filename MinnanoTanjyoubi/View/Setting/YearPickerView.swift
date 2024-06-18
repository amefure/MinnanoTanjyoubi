//
//  YearPickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import SwiftUI

struct YearPickerView: View {
    @StateObject var viewModel: SettingViewModel

    @State private var year: Int = 0

    var body: some View {
        Picker("登録年数初期値", selection: $year) {
            ForEach(viewModel.yearArray, id: \.self) { year in
                Text("\(String(year))年")
            }
        }.tint(.white)
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
