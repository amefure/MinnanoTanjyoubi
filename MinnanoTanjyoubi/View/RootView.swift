//
//  ContentView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift
import SwiftUI

struct RootView: View {
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Contents

            HeaderView()

            // MARK: - Main Contents

            RootListUserView()

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
