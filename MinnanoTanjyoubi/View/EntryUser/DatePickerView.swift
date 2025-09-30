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
    @State private var dateStr: String = ""
    @Binding var showWheel: Bool
    @Binding var isYearsUnknown: Bool
    private let isSESize: Bool = DeviceSizeUtility.isSESize

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        HStack {
            if showWheel {
                DatePicker(
                    selection: $date,
                    displayedComponents: DatePickerComponents.date,
                    label: { Text("誕生日") }
                ).environment(\.locale, Locale(identifier: "ja_JP"))
                    .environment(\.calendar, Calendar(identifier: .gregorian))
                    .onChange(of: date) { newValue in
                        if isYearsUnknown {
                            dateStr = dfm.getJpStringOnlyDate(date: newValue)
                        } else {
                            dateStr = dfm.getJpString(date: newValue)
                        }
                    }
                    .colorInvert()
                    .colorMultiply(rootEnvironment.scheme.text)
                    .frame(width: DeviceSizeUtility.deviceWidth - 180)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .scaleEffect(x: isSESize ? 0.8 : 0.9, y: isSESize ? 0.8 : 0.9)

                Button {
                    showWheel = false
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(rootEnvironment.scheme.thema2)
                        .opacity(0.8)
                        .cornerRadius(5)
                }.padding([.leading, .top, .bottom])
            } else {
                Text(dateStr)
                    .fontM()
                    .frame(width: DeviceSizeUtility.deviceWidth - 120)
                    .onTapGesture {
                        showWheel = true
                    }.onChange(of: isYearsUnknown) { _ in
                        if isYearsUnknown {
                            dateStr = dfm.getJpStringOnlyDate(date: date)
                        } else {
                            dateStr = dfm.getJpString(date: date)
                        }
                    }
            }
        }.onAppear {
            if isYearsUnknown {
                dateStr = dfm.getJpStringOnlyDate(date: date)
            } else {
                dateStr = dfm.getJpString(date: date)
            }
        }
    }
}

#Preview {
    DatePickerView(date: Binding.constant(Date()), showWheel: Binding.constant(true), isYearsUnknown: Binding.constant(true))
        .environmentObject(RootEnvironment())
}
