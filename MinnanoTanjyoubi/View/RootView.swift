//
//  ContentView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @ObservedObject private var viewModel = RootViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environmentObject(rootEnvironment)

            RootListUserView()
                .environmentObject(rootEnvironment)

            AdMobBannerView()
                .frame(height: 50)

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .onOpenURL { url in
                /// Custom URL Schemeでアプリを起動した場合のハンドリング
                guard let query = url.query() else { return }
                guard let users = viewModel.decryptAndInitializeUsers(query) else { return }
                print("users", users.count)
                for user in users {
                    if repository.shareCreateUser(shareUser: user) {
                        viewModel.createUsers.append(user)
                        if user == users.last {
                            print("---ebd")
                            repository.readAllUsers()
                            viewModel.showSuccessCreateUser = true
                        }
                    } else {
                        // 失敗したら終了する
                        viewModel.showExistUserError = true
                        break
                    }
                }

            }.alert(
                isPresented: $viewModel.showSuccessCreateUser,
                title: "登録成功",
                message: viewModel.createUsers.count == 1 ? "「\(viewModel.createUsers.first!.name)」さんの誕生日情報を登録しました。" : "共有された誕生日情報を登録しました。"
            ).alert(
                isPresented: $viewModel.showExistUserError,
                title: "Error...",
                message: "共有された誕生日情報の登録に失敗しました。\nすでに同姓同名の誕生日情報が存在します。"
            )
    }
}

#Preview {
    RootView()
        .environmentObject(RootEnvironment())
}
