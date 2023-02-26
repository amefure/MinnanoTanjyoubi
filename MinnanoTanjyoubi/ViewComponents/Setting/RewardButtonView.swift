//
//  RewardButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import SwiftUI

struct RewardButtonView: View {
    
    // MARK: - AdMob
    @ObservedObject var reward = Reward()
    
    // MARK: - Storage
    @AppStorage("LimitCapacity") var limitCapacity = 5 // 初期値
    @AppStorage("LastAcquisitionDate") var lastAcquisitionDate = ""
    
    // MARK: - View
    @State var isAlertReward:Bool = false      // リワード広告視聴回数制限アラート
    
    // MARK: - Method
    private func nowTime() -> String{
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateStyle = .short
        df.timeStyle = .none
        return df.string(from: Date())
    }
    
    
    var body: some View {
        Button(action: {
            // 1日1回までしか視聴できないようにする
            if lastAcquisitionDate != nowTime() {
                reward.showReward()          //  広告配信
                limitCapacity = limitCapacity + 5
                lastAcquisitionDate = nowTime() // 最終視聴日を格納
                
            }else{
                isAlertReward = true
            }
        }) {
            HStack{
                Image(systemName:"bag.badge.plus").settingIcon()
                Text("広告を視聴して容量を追加する")
                Spacer()
                Text("容量:\(limitCapacity)人")
            }
        }
        .onAppear() {
            reward.loadReward()
        }
        .disabled(!reward.rewardLoaded)
        .alert(Text("お知らせ"),
               isPresented: $isAlertReward,
               actions: {
            Button(action: {
            }, label: {
                Text("OK")
            })
        }, message: {
            Text("広告を視聴できるのは1日に1回までです")
        })
    }
}

struct RewardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RewardButtonView()
    }
}
