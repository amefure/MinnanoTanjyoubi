//
//  ShareUserLinkView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/12.
//

import SwiftUI

struct ShareUserLinkView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(ShareUserLinkViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("誕生日情報共有")
                .fontL()
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .fontWeight(.bold)
                .padding(.vertical)

            Text("「みんなの誕生日」をインストールしている人に自分が登録している誕生日情報をシェアすることができます。\n共有したい誕生日情報を選択して「共有する」をクリックしてください。")
                .fontS()
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.horizontal)

            List {
                ForEach(viewModel.allUsers.sorted { $0.name < $1.name }, id: \.self) { user in
                    Button {
                        viewModel.addOrDeleteShareUser(user)
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text(user.name)

                            Spacer()

                            if viewModel.shareUsers.contains(user) {
                                Image(systemName: "checkmark")
                            }

                        }.foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            .fontM(bold: true)
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.state.scheme.foundationSub)

            Button {
                viewModel.shareUser()
            } label: {
                Text("共有する")
                    .fontM()
            }.frame(width: DeviceSizeUtility.deviceWidth - 80, height: 50)
                .background(!viewModel.shareUsers.isEmpty ? Asset.Colors.exThemaRed.swiftUIColor : Asset.Colors.exText.swiftUIColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 4, y: 4)
                .disabled(viewModel.shareUsers.isEmpty)

            Spacer()

        }.background(rootEnvironment.state.scheme.foundationSub)
            .onAppear { viewModel.onAppear() }
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ShareUserLinkView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
