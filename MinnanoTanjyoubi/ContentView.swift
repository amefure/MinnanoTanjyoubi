//
//  ContentView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    // MARK: - Modal Control 設定画面遷移
    @State var isSettingActive:Bool = false

    var body: some View {
        VStack(spacing:0){
            
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
       
        }.background(ColorAsset.foundationColorLight.thisColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
