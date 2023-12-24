//
//  RewardButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import SwiftUI

struct RewardButtonView: View {
    // MARK: - AdMob

    @StateObject var reward = Reward()

    // MARK: - Method

    @StateObject var viewModel: SettingViewModel

    var body: some View {
        Button(action: {
            // 1日1回までしか視聴できないようにする
            if viewModel.checkAcquisitionDate() {
                reward.showReward() //  広告配信
                viewModel.addCapacity()
                viewModel.registerAcquisitionDate()

            } else {
                viewModel.isAlertReward = true
            }
        }) {
            HStack {
                Image(systemName: "bag.badge.plus")
                    .settingIcon()
                Text(reward.rewardLoaded ? "広告を視聴して容量を追加する" : "広告を読み込んでいます")
            }
        }
        .onAppear { reward.loadReward() }
        .disabled(!reward.rewardLoaded)
        .alert(Text("お知らせ"),
               isPresented: $viewModel.isAlertReward,
               actions: {
                   Button(action: {}, label: {
                       Text("OK")
                   })
               }, message: {
                   Text("広告を視聴できるのは1日に1回までです。")
               })
    }
}

struct RewardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RewardButtonView(viewModel: SettingViewModel())
    }
}
