//
//  RootView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct RootView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    @State private var popUpViewModel: TutorialPopUpViewModel
    @State private var viewModel: RootViewModel

    init(container: DIContainer = .shared) {
        let localRepository = container.resolve(RealmRepository.self)
        let userDefaultsRepository = container.resolve(UserDefaultsRepository.self)
        popUpViewModel = TutorialPopUpViewModel(
            localRepository: localRepository,
            userDefaultsRepository: userDefaultsRepository
        )
        viewModel = RootViewModel(
            localRepository: localRepository,
            userDefaultsRepository: userDefaultsRepository
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()

            RootListUserView()

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
                isPresented: $viewModel.state.isShowShareCreateSuccessAlert,
                title: "登録成功",
                message: viewModel.state.createUsers.count == 1 ? "「\(viewModel.state.createUsers.first!.name)」さんの誕生日情報を登録しました。" : "共有された誕生日情報を登録しました。"
            ).alert(
                isPresented: $viewModel.state.isShowShareCreateFailedAlert,
                title: "Error...",
                message: viewModel.state.shareCreateError.message
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
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
