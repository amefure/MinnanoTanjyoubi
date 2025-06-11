//
//  SelectInitWeekView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/11.
//

import SwiftUI

struct SelectInitWeekView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @State private var selectWeek: SCWeek = .sunday
    @State private var showSuccessAlert = false

    // MARK: - Environment

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("週始まり変更")
                .fontL(bold: true)
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .padding(.vertical)

            Text("カレンダーの週の始まりの曜日を変更することができます。")
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .padding(.top, 10)
                .font(.caption)

            List {
                ForEach(SCWeek.allCases, id: \.self) { week in
                    Button {
                        selectWeek = week
                    } label: {
                        HStack {
                            Text(week.fullSymbols)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            Spacer()

                            if selectWeek == week {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                            }
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))

            Spacer()

            DownSideView(parentFunction: {
                rootEnvironment.saveInitWeek(week: selectWeek)
                showSuccessAlert = true
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)
        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .fontM()
            .navigationBarBackButtonHidden()
            .alert(
                isPresented: $showSuccessAlert,
                title: "お知らせ",
                message: "週始まりを変更しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            ).onAppear {
                selectWeek = rootEnvironment.getInitWeek()
            }
    }
}

#Preview {
    SelectInitWeekView()
}
