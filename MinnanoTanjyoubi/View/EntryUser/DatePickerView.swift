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

    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                           .colorInvert()
                           .colorMultiply(AppColorScheme.getText(rootEnvironment.scheme))
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
                    .foregroundStyle(.white)
                    .padding(3)
                    .background(isWheel ? AppColorScheme.getThema2(rootEnvironment.scheme) : AppColorScheme.getThema3(rootEnvironment.scheme)).opacity(0.8)
                    .cornerRadius(5)
            }).padding([.leading, .top, .bottom])
        }
        .onAppear {
            dateStr = dfm.getJpString(date: date)
        }
    }
}
