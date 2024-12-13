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

            Text("「みんなの誕生日」をインストールしている人に自分が登録している誕生日情報をシェアすることができます。\n共有したい人を選択してください")
                .fontS()
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .padding(.horizontal)

            List {
                ForEach(repository.users.sorted { $0.name < $1.name }, id: \.self) { user in
                    Button {
                        ShareInfoUtillity.shareBirthday(user)
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text(user.name)

                        }.foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            .fontM(bold: true)
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ShareUserLinkView()
        .environmentObject(RootEnvironment())
}
