//
//  RootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @ObservedObject private var popUpViewModel = DIContainer.shared.resolve(TutorialPopUpViewModel.self)
    @ObservedObject private var viewModel = DIContainer.shared.resolve(RootViewModel.self)

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environmentObject(rootEnvironment)

            RootListUserView()
                .environmentObject(rootEnvironment)

            if !rootEnvironment.state.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(rootEnvironment.state.scheme.foundationSub)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .onAppear { popUpViewModel.onAppear() }
            .onOpenURL { url in
                // Custom URL Schemeでアプリを起動した場合のハンドリング
                viewModel.copyUserFromUrlScheme(url: url)
            }.alert(
                isPresented: $viewModel.showSuccessCreateUser,
                title: "登録成功",
                message: viewModel.createUsers.count == 1 ? "「\(viewModel.createUsers.first!.name)」さんの誕生日情報を登録しました。" : "共有された誕生日情報を登録しました。"
            ).alert(
                isPresented: $viewModel.showCreateShareUserError,
                title: "Error...",
                message: viewModel.error?.message ?? "共有された誕生日情報の登録に失敗しました。"
            ).tutorialPopupView(
                isPresented: $popUpViewModel.state.isPresented,
                title: popUpViewModel.state.title,
                message: popUpViewModel.state.message,
                buttonTitle: popUpViewModel.state.buttonTitle,
                buttonAction: popUpViewModel.state.buttonAction,
                popupWidth: DeviceSizeUtility.deviceWidth,
                headerHeight: DeviceSizeUtility.isSESize ? 10 : 50,
                footerHeight: DeviceSizeUtility.isSESize ? 120 : 140,
                position: popUpViewModel.state.position
            )
    }
}

#Preview {
    RootView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
