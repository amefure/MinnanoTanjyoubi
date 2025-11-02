//
//  AppLockView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import SwiftUI

struct AppLockView: View {
    @State private var viewModel = DIContainer.shared.resolve(AppLockViewModel.self)
    @State private var password: [String] = []
    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowIcon: false)

            Spacer()

            ZStack {
                DisplayPasswordView(password: password)
                    .onChange(of: password) { _, newValue in
                        viewModel.passwordLogin(password: newValue) { result in
                            if result == false {
                                password.removeAll()
                            }
                        }
                    }

                if viewModel.state.isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                } else {
                    Button {
                        Task {
                            await viewModel.requestBiometricsLogin()
                        }
                    } label: {
                        VStack {
                            if viewModel.state.type == .faceID {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Face IDでログインする")
                            } else if viewModel.state.type == .touchID {
                                Image(systemName: "touchid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Touch IDでログインする")
                            }
                        }
                    }.offset(y: 80)
                        .foregroundStyle(rootEnvironment.state.scheme.text)
                }
            }

            Spacer()

            NumberKeyboardView(password: $password)
                .ignoresSafeArea(.all)
        }.alert(
            isPresented: $viewModel.state.isShowFailureAlert,
            title: "Erroe",
            message: "パスワードが違います。"
        ).navigationDestination(isPresented: $viewModel.state.isShowApp) {
            RootView()
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .background(rootEnvironment.state.scheme.foundationSub)
    }
}

struct NumberKeyboardView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment

    @Binding var password: [String]

    private var height: CGFloat {
        DeviceSizeUtility.isSESize ? 60 : 80
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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                        .frame(width: DeviceSizeUtility.deviceWidth / 3, height: height)
                        .background(rootEnvironment.state.scheme.foundationPrimary)
                }
            }
        }.foregroundStyle(rootEnvironment.state.scheme.text)
            .fontWeight(.bold)
    }
}

/// 4桁のブラインドパスワードビュー
struct DisplayPasswordView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment

    let password: [String]

    var body: some View {
        HStack(spacing: 30) {
            Text(password[safe: 0] == nil ? "ー" : "⚫︎")
            Text(password[safe: 1] == nil ? "ー" : "⚫︎")
            Text(password[safe: 2] == nil ? "ー" : "⚫︎")
            Text(password[safe: 3] == nil ? "ー" : "⚫︎")
        }.foregroundStyle(rootEnvironment.state.scheme.text)
            .fontWeight(.bold)
    }
}

/// 数値入力カスタムキーボード
struct NumberButton: View {
    @Environment(\.rootEnvironment) private var rootEnvironment

    let number: String
    @Binding var password: [String]

    private var height: CGFloat {
        DeviceSizeUtility.isSESize ? 60 : 80
    }

    var body: some View {
        Button {
            if password.count != 4, number != "-" {
                password.append(number)
            }
        } label: {
            Text(number)
                .frame(width: DeviceSizeUtility.deviceWidth / 3, height: height)
                .background(rootEnvironment.state.scheme.foundationPrimary)
        }
    }
}

#Preview {
    AppLockView()
}
