//
//  ContentView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct RootView: View {
    // MARK: - Environment

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Contents

            HeaderView()

            #if DEBUG

                // MARK: - 現在登録されている通知をすべて表示するコマンド

//            Button {
//                AppManager.sharedNotificationRequestManager.confirmNotificationRequest()
//            } label: {
//                Text("全登録済み通知を表示")
//            }
            #endif

            // MARK: - Main Contents

            ListUserView()
                .environmentObject(rootEnvironment)

            // MARK: - AdMob

            AdMobBannerView()
                .frame(height: 50)

        }.background(ColorAsset.foundationColorLight.thisColor)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
