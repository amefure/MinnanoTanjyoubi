//
//  RewardButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import SwiftUI

struct RewardButtonView: View {
    @StateObject private var reward = Reward()
    private let viewModel = RewardViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isAlertReward = false

    var body: some View {
        Button {
            // 1日1回までしか視聴できないようにする
            if viewModel.checkAcquisitionDate() {
                reward.showReward() //  広告配信
                viewModel.addCapacity()
                viewModel.registerAcquisitionDate()

            } else {
                isAlertReward = true
            }
        } label: {
            HStack {
                Text(reward.rewardLoaded ? "広告を視聴して容量を追加する" : "広告を読み込んでいます")
                    .foregroundStyle(.white)
                    .fontS(bold: true)
                // 読み込み中のプログレス表示
                if !reward.rewardLoaded {
                    ProgressView()
                        .tint(.white)
                        .padding(.leading, 8)
                }
            }
        }.frame(width: DeviceSizeUtility.deviceWidth - 80, height: 50)
            .background(reward.rewardLoaded ? Asset.Colors.exThemaRed.swiftUIColor : Asset.Colors.exText.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray, radius: 3, x: 4, y: 4)
            .onAppear { reward.loadReward() }
            .disabled(!reward.rewardLoaded)
            .alert(
                isPresented: $isAlertReward,
                title: "Sorry...",
                message: "広告を視聴できるのは1日に1回までです。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    isAlertReward = false
                },
                negativeAction: {}
            )
    }
}

#Preview {
    RewardButtonView()
        .environmentObject(RootEnvironment())
}
