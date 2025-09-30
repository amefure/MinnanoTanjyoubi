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
    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
            .colorMultiply(rootEnvironment.scheme.text)
            .onChange(of: time) { newValue in
                viewModel.registerNotifyTime(date: newValue)
            }.onAppear {
                time = viewModel.getNotifyTimeDate()
            }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(viewModel: SettingViewModel())
    }
}
