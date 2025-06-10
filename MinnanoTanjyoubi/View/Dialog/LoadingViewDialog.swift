//
//  LoadingViewDialog.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/10.
//

import Combine
import SwiftUI

struct LoadingViewDialog: View {
    @StateObject private var viewModel = LoadingDialogViewModel()
    /// アニメーションの回転角度
    @State private var degrees: Double = 0.0
    /// アニメーションロジック(ViewModelに移植すると動作しない)
    @State private var timerPublisher: AnyCancellable?

    private let imageSize: CGFloat = 50

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // 画面全体を覆う透明背景
                Color.clear

                // ダイアログコンテンツ部分
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        Asset.Images.appiconRemove.swiftUIImage
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .rotationEffect(Angle(degrees: -degrees))
                            .offset(x: 0, y: -30)

                        Asset.Images.appiconRemove.swiftUIImage
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .rotationEffect(Angle(degrees: -degrees))
                            .offset(x: -30, y: 0)

                        Asset.Images.appiconRemove.swiftUIImage
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .rotationEffect(Angle(degrees: -degrees))
                            .offset(x: 30, y: 0)

                        Asset.Images.appiconRemove.swiftUIImage
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .rotationEffect(Angle(degrees: -degrees))
                            .offset(y: 30)
                    }.frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                        .rotationEffect(Angle(degrees: degrees))
                        .onAppear {
                            timerPublisher = Timer.publish(every: 0.1, on: .current, in: .common)
                                .autoconnect()
                                .sink { _ in
                                    withAnimation {
                                        degrees += 15
                                    }
                                }
                        }
                }.frame(width: 300, height: 220)
            }
        }.ignoresSafeArea()
            .onAppear {
                viewModel.onAppear()
            }.onDisappear {
                viewModel.onDisappear()
                timerPublisher?.cancel()
            }
    }
}

extension View {
    func overlayLoadingDialog() -> some View {
        overlay(
            LoadingViewDialog()
        )
    }
}

#Preview {
    LoadingViewDialog()
}
