//
//  AppLockView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import SwiftUI

struct AppLockView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(AppLockViewModel.self)
    @State private var password: [String] = []

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowIcon: false)
                .environmentObject(rootEnvironment)

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

                if viewModel.isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                } else {
                    Button {
                        Task {
                            await viewModel.requestBiometricsLogin()
                        }
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
                        .foregroundStyle(rootEnvironment.scheme.text)
                }
            }

            Spacer()

            NumberKeyboardView(password: $password)
                .ignoresSafeArea(.all)
        }.alert(
            isPresented: $viewModel.isShowFailureAlert,
            title: "Erroe",
            message: "パスワードが違います。"
        ).navigationDestination(isPresented: $viewModel.isShowApp) {
            RootView()
                .environmentObject(rootEnvironment)
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .background(rootEnvironment.scheme.foundationSub)
    }
}

struct NumberKeyboardView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @Binding var password: [String]

    private var height: CGFloat {
        DeviceSizeUtility.isSESize ? 60 : 80
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                NumberButton(number: "1", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "2", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "3", password: $password)
                    .environmentObject(rootEnvironment)
            }

            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "4", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "5", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "6", password: $password)
                    .environmentObject(rootEnvironment)
            }

            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "7", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "8", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "9", password: $password)
                    .environmentObject(rootEnvironment)
            }

            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "-", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "0", password: $password)
                    .environmentObject(rootEnvironment)

                Rectangle()
                    .frame(width: 1, height: height)

                Button {
                    password = password.dropLast()
                } label: {
                    Image(systemName: "delete.backward")
                        .frame(width: DeviceSizeUtility.deviceWidth / 3, height: height)
                        .background(rootEnvironment.scheme.foundationPrimary)
                }
            }
        }.foregroundStyle(rootEnvironment.scheme.text)
            .fontWeight(.bold)
    }
}

/// 4桁のブラインドパスワードビュー
struct DisplayPasswordView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    let password: [String]

    var body: some View {
        HStack(spacing: 30) {
            Text(password[safe: 0] == nil ? "ー" : "⚫︎")
            Text(password[safe: 1] == nil ? "ー" : "⚫︎")
            Text(password[safe: 2] == nil ? "ー" : "⚫︎")
            Text(password[safe: 3] == nil ? "ー" : "⚫︎")
        }.foregroundStyle(rootEnvironment.scheme.text)
            .fontWeight(.bold)
    }
}

/// 数値入力カスタムキーボード
struct NumberButton: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                .background(rootEnvironment.scheme.foundationPrimary)
        }
    }
}

#Preview {
    AppLockView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
