//
//  SelectInitWeekView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/11.
//

import SCCalendar
import SwiftUI

struct SelectInitWeekView: View {
    @State private var viewModel = DIContainer.shared.resolve(SelectInitWeekViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView(scheme: rootEnvironment.state.scheme)

            Text("週始まり変更")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            Text("カレンダーの週の始まりの曜日を変更することができます。")
                .foregroundStyle(rootEnvironment.state.scheme.text)
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

                            if viewModel.state.selectWeek == week {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(rootEnvironment.state.scheme.foundationPrimary)
                            }
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.state.scheme.foundationSub)

            Spacer()

            DownSideView(
                parentFunction: {
                    viewModel.registerInitWeek()
                },
                imageString: "checkmark",
                scheme: rootEnvironment.state.scheme
            )

        }.background(rootEnvironment.state.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
            .alert(
                isPresented: $viewModel.state.isShowSuccessAlert,
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
