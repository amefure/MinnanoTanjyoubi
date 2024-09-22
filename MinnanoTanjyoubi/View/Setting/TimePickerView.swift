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

    @State private var time: Date = .init()

    var body: some View {
        DatePicker(
            selection: $time,
            displayedComponents: DatePickerComponents.hourAndMinute,
            label: {
                Text("通知時間")
                    .foregroundStyle(AppColorScheme.getText())
                    .font(.system(size: 17))
            }
        ).environment(\.locale, Locale(identifier: "ja_JP"))
            .font(.system(size: 17))
            .colorInvert()
            .colorMultiply(AppColorScheme.getText())
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
