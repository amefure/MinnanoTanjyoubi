//
//  SelectSortView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import SwiftUI

struct SelectSortView: View {
    @State private var sort: AppSortItem = .daysLater
    @State private var isAlert = false

    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("並び順変更")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            List {
                ForEach(AppSortItem.allCases, id: \.self) { sort in
                    Button {
                        self.sort = sort
                    } label: {
                        HStack {
                            Text(sort.name)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                                .fontWeight(.bold)
                                .font(.system(size: 17))

                            Spacer()

                            if self.sort == sort {
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
                UIApplication.shared.closeKeyboard()

                rootEnvironment.registerSortItem(sort)
                repository.readAllUsers(sort: sort)
                isAlert = true
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .font(.system(size: 17))
            .navigationBarBackButtonHidden()
            .onAppear {
                sort = rootEnvironment.sort
            }.alert(
                isPresented: $isAlert,
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
