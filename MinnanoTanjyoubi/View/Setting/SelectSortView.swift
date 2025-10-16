//
//  SelectSortView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import SwiftUI

struct SelectSortView: View {
    @ObservedObject private var viewModel = SelectSortViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("並び順変更")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.scheme.text)
                .padding(.vertical)

            List {
                ForEach(AppSortItem.allCases, id: \.self) { sort in
                    Button {
                        viewModel.setSortItem(sort: sort)
                    } label: {
                        HStack {
                            Text(sort.name)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                                .fontWeight(.bold)
                                .font(.system(size: 17))

                            Spacer()

                            if viewModel.sort == sort {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(rootEnvironment.scheme.foundationPrimary)
                            }
                        }
                    }
                }

            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.scheme.foundationSub)

            Spacer()

            DownSideView(parentFunction: {
               
                viewModel.registerSortItem()
              
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

        }.background(rootEnvironment.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.onAppear()
            }.alert(
                isPresented: $viewModel.isShowSuccessAlert,
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
}
