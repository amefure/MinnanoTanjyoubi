//
//  ShareUserLinkView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/12.
//

import SwiftUI

struct ShareUserLinkView: View {
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var shareUsers: [User] = []

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("誕生日情報共有")
                .fontL()
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            Text("「みんなの誕生日」をインストールしている人に自分が登録している誕生日情報をシェアすることができます。\n共有したい誕生日情報を選択して「共有する」をクリックしてください。")
                .fontS()
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .padding(.horizontal)

            List {
                ForEach(repository.users.sorted { $0.name < $1.name }, id: \.self) { user in
                    Button {
                        if shareUsers.contains(user) {
                            shareUsers.removeAll(where: { $0.id == user.id })
                        } else {
                            shareUsers.append(user)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text(user.name)

                            Spacer()

                            if shareUsers.contains(user) {
                                Image(systemName: "checkmark")
                            }

                        }.foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            .fontM(bold: true)
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))

            Button {
                ShareInfoUtillity.shareBirthday(shareUsers)
            } label: {
                Text("共有する")
                    .fontM()
            }.frame(width: DeviceSizeUtility.deviceWidth - 80, height: 50)
                .background(shareUsers.count != 0 ? Asset.Colors.exThemaRed.swiftUIColor : Asset.Colors.exText.swiftUIColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 4, y: 4)
                .disabled(shareUsers.count == 0)

            Spacer()

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ShareUserLinkView()
        .environmentObject(RootEnvironment())
}
