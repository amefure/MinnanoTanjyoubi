//
//  TimePickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/06.
//

import SwiftUI

// MARK: - 通知時間設定タイムピッカービュー

// 選択された時間を「6-0」形式でuserDefaultsに保存する
struct TimePickerView: View {
    // MARK: - Storage

    @AppStorage("NoticeTime") var noticeTime: String = "6-0"

    // MARK: - 初期値は「6:00」

    @State var time: Date = {
        let userDefaults = UserDefaults.standard
        let timeStr = userDefaults.object(forKey: "NoticeTime") as? String ?? "6-0" as String
        let timeArray: [Substring] = timeStr.split(separator: "-")
        let hour = Int(timeArray[0])
        let minute = Int(timeArray[1])
        return Calendar.current.date(from: DateComponents(hour: hour, minute: minute))!
    }()

    var body: some View {
        DatePicker(selection: $time,
                   displayedComponents: DatePickerComponents.hourAndMinute,
                   label: {
                       Text("通知時間").foregroundColor(.black)
                   }).environment(\.locale, Locale(identifier: "ja_JP"))
            .colorInvert()
            .colorMultiply(.white)
            .onChange(of: time) { newValue in
                let df = DateFormatter()
                df.dateFormat = "H-mm"
                noticeTime = df.string(from: newValue)
            }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView()
    }
}
