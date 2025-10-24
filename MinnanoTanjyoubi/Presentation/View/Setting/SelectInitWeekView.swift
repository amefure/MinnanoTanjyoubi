//
//  SelectInitWeekView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/11.
//

import SwiftUI

struct SelectInitWeekView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(SelectInitWeekViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("週始まり変更")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.scheme.text)
                .padding(.vertical)

            Text("カレンダーの週の始まりの曜日を変更することができます。")
                .foregroundStyle(rootEnvironment.scheme.text)
                .padding(.top, 10)
                .font(.caption)

            List {
                ForEach(SCWeek.allCases, id: \.self) { week in
                    Button {
                        viewModel.setWeek(week: week)
                    } label: {
                        HStack {
                            Text(week.fullSymbols)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            Spacer()

                            if viewModel.selectWeek == week {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(rootEnvironment.scheme.foundationPrimary)
                            }
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.scheme.foundationSub)

            Spacer()

            DownSideView(
                parentFunction: {
                    viewModel.registerInitWeek()
                },
                imageString: "checkmark"
            ).environmentObject(rootEnvironment)

        }.background(rootEnvironment.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
            .alert(
                isPresented: $viewModel.isShowSuccessAlert,
                title: "お知らせ",
                message: "週始まりを変更しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            ).onAppear {
                viewModel.onAppear()
            }
    }
}

#Preview {
    SelectInitWeekView()
}
