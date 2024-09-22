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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
