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
    @ObservedObject private var popUpViewModel = TutorialPopUpViewModel()
    @ObservedObject private var viewModel = RootViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environmentObject(rootEnvironment)

            RootListUserView()
                .environmentObject(rootEnvironment)

            if !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(rootEnvironment.scheme.foundationSub)
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
                isPresented: $popUpViewModel.show,
                title: popUpViewModel.title,
                message: popUpViewModel.message,
                buttonTitle: popUpViewModel.buttonTitle,
                buttonAction: popUpViewModel.popupButtonAction,
                popupWidth: DeviceSizeUtility.deviceWidth,
                headerHeight: DeviceSizeUtility.isSESize ? 10 : 50,
                footerHeight: DeviceSizeUtility.isSESize ? 120 : 140,
                position: popUpViewModel.position
            )
    }
}

#Preview {
    RootView()
        .environmentObject(RootEnvironment())
}
