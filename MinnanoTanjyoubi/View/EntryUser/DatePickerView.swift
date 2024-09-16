//
//  DatePickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct DatePickerView: View {

    private let dfm = DateFormatUtility()

    @Binding var date: Date
    @State var dateStr: String = ""
    @Binding var isWheel: Bool

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let deviceHeight = DeviceSizeUtility.deviceHeight
    private let isSESize: Bool = DeviceSizeUtility.isSESize

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
                    .background(isWheel ? Asset.Colors.themaColor2.swiftUIColor : Asset.Colors.themaColor3.swiftUIColor).opacity(0.8)
                    .cornerRadius(5)
            }).padding([.leading, .top, .bottom])
        }
        .onAppear {
            dateStr = dfm.getJpString(date: date)
        }
    }
}
