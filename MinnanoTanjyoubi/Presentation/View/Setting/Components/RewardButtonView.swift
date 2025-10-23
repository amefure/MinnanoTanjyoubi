//
//  RewardButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import SwiftUI

struct RewardButtonView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(RewardViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        Button {
            Task {
                //  広告配信
                await viewModel.showReward()
            }
        } label: {
            HStack {
                Text(viewModel.rewardLoaded ? "広告を視聴して容量を追加する" : "広告を読み込んでいます")
                    .foregroundStyle(.white)
                    .fontS(bold: true)
                // 読み込み中のプログレス表示
                if !viewModel.rewardLoaded {
                    ProgressView()
                        .tint(.white)
                        .padding(.leading, 8)
                }
            }.frame(width: DeviceSizeUtility.deviceWidth - 80, height: 50)
                .background(Asset.Colors.exThemaRed.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 4, y: 4)
        }.buttonStyle(.plain)
            .onAppear {
                Task {
                    await viewModel.loadReward()
                }
            }
            .disabled(!viewModel.rewardLoaded)
            .alert(
                isPresented: $viewModel.isShowAlert,
                title: "Sorry...",
                message: "広告を視聴できるのは1日に1回までです。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    viewModel.isShowAlert = false
                }
            )
    }
}

#Preview {
    RewardButtonView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
