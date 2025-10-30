//
//  SelectSortView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import SwiftUI

struct SelectSortView: View {
    @State private var viewModel = DIContainer.shared.resolve(SelectSortViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environment(\.rootEnvironment, rootEnvironment)

            Text("並び順変更")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            List {
                ForEach(AppSortItem.allCases, id: \.self) { sort in
                    Button {
                        viewModel.setSortItem(sort: sort)
                    } label: {
                        HStack {
                            Text(sort.name)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                                .fontM(bold: true)

                            Spacer()

                            if viewModel.state.sort == sort {
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
                    viewModel.registerSortItem()
                },
                imageString: "checkmark"
            ).environment(\.rootEnvironment, rootEnvironment)

        }.background(rootEnvironment.state.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.onAppear()
            }.alert(
                isPresented: $viewModel.state.isShowSuccessAlert,
                title: "お知らせ",
                message: "並び順を変更しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
    }
}

#Preview {
    SelectSortView()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
