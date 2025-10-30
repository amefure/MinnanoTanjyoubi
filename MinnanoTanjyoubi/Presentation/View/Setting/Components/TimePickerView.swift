//
//  TimePickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/06.
//

import SwiftUI

// 通知時間設定タイムピッカービュー
struct TimePickerView: View {
    @StateObject var viewModel: SettingViewModel
    @Environment(\.rootEnvironment) private var rootEnvironment

    @State private var time: Date = .init()

    var body: some View {
        DatePicker(
            selection: $time,
            displayedComponents: DatePickerComponents.hourAndMinute,
            label: { Text("通知時間") }
        ).labelsHidden()
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .fontM()
            .colorInvert()
            .colorMultiply(rootEnvironment.state.scheme.text)
            .onChange(of: time) { _, newValue in
                viewModel.registerNotifyTime(date: newValue)
            }.onAppear {
                time = viewModel.getNotifyTimeDate()
            }
    }
}

#Preview {
    TimePickerView(viewModel: DIContainer.shared.resolve(SettingViewModel.self))
}
