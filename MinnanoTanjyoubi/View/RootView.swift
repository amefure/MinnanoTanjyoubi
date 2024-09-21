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
            // Header Contents
            HeaderView()

            // Main Contents
            RootListUserView()

            AdMobBannerView()
                .frame(height: 50)

        }.background(AppColorScheme.getFoundationSub())
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
