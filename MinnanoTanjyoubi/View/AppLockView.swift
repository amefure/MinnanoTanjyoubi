//
//  AppLockView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import SwiftUI

struct AppLockView: View {
    @State private var password: [String] = []
    @State private var isShowApp = false // アプリメイン画面遷移
    @State private var isShowProgress = false // プログレス表示
    @State private var isShowFailureAlert = false // パスワード失敗アラート

    // MARK: - Environment

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowSettingIcon: false)

            Spacer()

            ZStack {
                DisplayPasswordView(password: password)
                    .onChange(of: password) { newValue in
                        if newValue.count == 4 {
                            isShowProgress = true
                            let pass = newValue.joined(separator: "")
                            if pass == KeyChainRepository.sheard.getData() {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    isShowApp = true
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    isShowProgress = false
                                    isShowFailureAlert = true
                                    password.removeAll()
                                }
                            }
                        }
                    }

                if isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                }
            }

            Spacer()

            NumberKeyboardView(password: $password)
                .ignoresSafeArea(.all)
        }.alert("パスワードが違います。", isPresented: $isShowFailureAlert) {
            Button("OK") {}
        }
        .navigationDestination(isPresented: $isShowApp) {
            RootView()
                .environmentObject(rootEnvironment)
        }.background(ColorAsset.foundationColorLight.thisColor)
    }
}

struct NumberKeyboardView: View {
    @Binding var password: [String]

    private var height: CGFloat {
        DeviceSizeManager.isSESize ? 60 : 80
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                NumberButton(number: "1", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "2", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "3", password: $password)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "4", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "5", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "6", password: $password)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "7", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "8", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "9", password: $password)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "-", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "0", password: $password)

                Rectangle()
                    .frame(width: 1, height: height)

                Button {
                    password = password.dropLast()
                } label: {
                    Image(systemName: "delete.backward")
                        .frame(width: DeviceSizeManager.deviceWidth / 3, height: height)
                        .background(ColorAsset.foundationColorDark.thisColor)
                }
            }
        }.foregroundStyle(.white)
            .fontWeight(.bold)
    }
}

/// 4桁のブラインドパスワードビュー
struct DisplayPasswordView: View {
    let password: [String]

    var body: some View {
        HStack(spacing: 30) {
            Text(password[safe: 0] == nil ? "ー" : "⚫︎")
            Text(password[safe: 1] == nil ? "ー" : "⚫︎")
            Text(password[safe: 2] == nil ? "ー" : "⚫︎")
            Text(password[safe: 3] == nil ? "ー" : "⚫︎")
        }.foregroundStyle(.white)
            .fontWeight(.bold)
    }
}

/// 数値入力カスタムキーボード
struct NumberButton: View {
    public let number: String
    @Binding var password: [String]

    private var height: CGFloat {
        DeviceSizeManager.isSESize ? 60 : 80
    }

    var body: some View {
        Button {
            if password.count != 4 && number != "-" {
                password.append(number)
            }
        } label: {
            Text(number)
                .frame(width: DeviceSizeManager.deviceWidth / 3, height: height)
                .background(ColorAsset.foundationColorDark.thisColor)
        }
    }
}

#Preview {
    AppLockView()
}
