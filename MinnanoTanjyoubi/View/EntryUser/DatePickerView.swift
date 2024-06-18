//
//  DatePickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct DatePickerView: View {
    // MARK: - Models

    private let dfm = DateFormatUtility()

    // MARK: - View

    @Binding var date: Date
    @State var dateStr: String = ""
    @Binding var isWheel: Bool

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let deviceHeight = DeviceSizeManager.deviceHeight
    private let isSESize: Bool = DeviceSizeManager.isSESize

    var body: some View {
        HStack {
            if !isWheel {
                DatePicker(selection: $date,
                           displayedComponents: DatePickerComponents.date,
                           label: {
                               Text("誕生日")
                           })
                           .environment(\.locale, Locale(identifier: "ja_JP"))
                           .environment(\.calendar, Calendar(identifier: .gregorian))
                           .onChange(of: date) { newValue in
                               dateStr = dfm.getJpString(date: newValue)
                           }
                           .frame(width: isSESize ? 170 : 220)
                           .datePickerStyle(.wheel)
                           .labelsHidden()
                           .scaleEffect(x: isSESize ? 0.8 : 0.9, y: isSESize ? 0.8 : 0.9)
            } else {
                Text(dateStr).frame(width: isSESize ? 170 : 220)
            }

            Button(action: {
                isWheel.toggle()
            }, label: {
                Text(isWheel ? "変更" : "決定")
                    .padding(3)
                    .background(isWheel ? ColorAsset.themaColor2.thisColor : ColorAsset.themaColor3.thisColor).opacity(0.8)
                    .cornerRadius(5)
            }).padding([.leading, .top, .bottom])
        }
        .onAppear {
            dateStr = dfm.getJpString(date: date)
        }
    }
}
