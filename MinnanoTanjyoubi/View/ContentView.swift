//
//  ContentView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct ContentView: View {
    // MARK: - Modal Control 設定画面遷移

    @State var isSettingActive: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Contents

            HeaderView(isSettingActive: $isSettingActive)

            #if DEBUG

                // MARK: - 現在登録されている通知をすべて表示するコマンド

//            Button {
//                NotificationRequestManager().confirmNotificationRequest()
//            } label: {
//                Text("全登録済み通知を表示")
//            }
            #endif

            // MARK: - Main Contents

            ListUserView(isSettingActive: $isSettingActive)

            // MARK: - AdMob

            AdMobBannerView().frame(height: 50)

        }.background(ColorAsset.foundationColorLight.thisColor)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
