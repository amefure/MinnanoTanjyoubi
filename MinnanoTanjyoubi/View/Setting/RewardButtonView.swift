//
//  RewardButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import SwiftUI

struct RewardButtonView: View {
    @StateObject var reward = Reward()
    @StateObject var viewModel: SettingViewModel
    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                    .settingIcon(rootEnvironment.scheme)
                Text(reward.rewardLoaded ? "広告を視聴して容量を追加する" : "広告を読み込んでいます")
            }
        }
        .onAppear { reward.loadReward() }
        .disabled(!reward.rewardLoaded)
    }
}

struct RewardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RewardButtonView(viewModel: SettingViewModel())
    }
}
