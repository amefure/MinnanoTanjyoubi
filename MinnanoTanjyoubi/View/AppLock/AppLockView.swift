//
//  AppLockView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import SwiftUI

struct AppLockView: View {
    @StateObject private var viewModel = AppLockViewModel()

    @State private var password: [String] = []

    // MARK: - Environment

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowSettingIcon: false)

            Spacer()

            ZStack {
                DisplayPasswordView(password: password)
                    .onChange(of: password) { newValue in
                        viewModel.passwordLogin(password: newValue) { result in
                            if result == false {
                                password.removeAll()
                            }
                        }
                    }

                if viewModel.isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                } else {
                    Button {
                        viewModel.requestBiometricsLogin()
                    } label: {
                        VStack {
                            if viewModel.type == .faceID {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Face IDでログインする")
                            } else if viewModel.type == .touchID {
                                Image(systemName: "touchid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Touch IDでログインする")
                            }
                        }
                    }.offset(y: 80)
                        .foregroundStyle(.white)
                }
            }

            Spacer()

            NumberKeyboardView(password: $password)
                .ignoresSafeArea(.all)
        }.alert("パスワードが違います。", isPresented: $viewModel.isShowFailureAlert) {
            Button("OK") {}
        }
        .onAppear { viewModel.onAppear() }
        .navigationDestination(isPresented: $viewModel.isShowApp) {
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
