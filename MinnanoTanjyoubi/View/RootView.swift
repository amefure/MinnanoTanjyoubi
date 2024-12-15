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
                if let error = repository.shareCreateUsers(shareUsers: users) {
                    viewModel.showErrorAlert(error)
                } else {
                    viewModel.createUsers = users
                    repository.readAllUsers()
                    viewModel.showSuccessCreateUser = true
                }
            }.alert(
                isPresented: $viewModel.showSuccessCreateUser,
                title: "登録成功",
                message: viewModel.createUsers.count == 1 ? "「\(viewModel.createUsers.first!.name)」さんの誕生日情報を登録しました。" : "共有された誕生日情報を登録しました。"
            ).alert(
                isPresented: $viewModel.showCreateShareUserError,
                title: "Error...",
                message: viewModel.error?.message ?? "共有された誕生日情報の登録に失敗しました。"
            )
    }
}

#Preview {
    RootView()
        .environmentObject(RootEnvironment())
}
