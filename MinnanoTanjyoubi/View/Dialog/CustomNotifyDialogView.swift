//
//  CustomNotifyDialogView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct CustomNotifyDialogView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    @Binding var isPresented: Bool

    public let title: String
    public let message: String
    public let positiveButtonTitle: String
    public let negativeButtonTitle: String
    public let positiveAction: () -> Void
    public let negativeAction: () -> Void

    var body: some View {
        if isPresented {
            ZStack {
                // 画面全体を覆う黒い背景
                Color.black
                    .opacity(0.3)
                    .onTapGesture {
                        // ダイアログ周りタップで閉じる
                        // isPresented = false
                    }

                // ダイアログコンテンツ部分
                VStack(spacing: 0) {
                    Text(title)
                        .frame(width: 300)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                        .padding(.vertical, 20)
                        .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                    Spacer()

                    Text(message)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 20)
                        .fontWeight(.bold)
                        .lineLimit(4)

                    Spacer()

                    Divider()

                    HStack(spacing: 0) {
                        if !negativeButtonTitle.isEmpty {
                            Button {
                                isPresented = false
                                negativeAction()
                            } label: {
                                Text(negativeButtonTitle)
                                    .frame(width: positiveButtonTitle.isEmpty ? 300 : 150, height: 20)
                                    .foregroundStyle(.gray)
                            }
                        }

                        if !negativeButtonTitle.isEmpty && !negativeButtonTitle.isEmpty {
                            Divider()
                                .frame(height: 20)
                        }

                        if !positiveButtonTitle.isEmpty {
                            Button {
                                isPresented = false
                                positiveAction()
                            } label: {
                                Text(positiveButtonTitle)
                                    .frame(width: negativeButtonTitle.isEmpty ? 300 : 150, height: 20)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }.padding()

                }.frame(width: 300, height: 220)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                // 画面一杯にViewを広げる
            }.font(.system(size: 17))
                .ignoresSafeArea()
        }
    }
}

extension View {
    func dialog(isPresented: Binding<Bool>,
                title: String,
                message: String,
                positiveButtonTitle: String = "",
                negativeButtonTitle: String = "",
                positiveAction: @escaping () -> Void = {},
                negativeAction: @escaping () -> Void = {}) -> some View
    {
        overlay(
            CustomNotifyDialogView(
                isPresented: isPresented,
                title: title,
                message: message,
                positiveButtonTitle: positiveButtonTitle,
                negativeButtonTitle: negativeButtonTitle,
                positiveAction: positiveAction,
                negativeAction: negativeAction
            )
        )
    }
}

#Preview {
    CustomNotifyDialogView(
        isPresented: Binding.constant(true),
        title: "通知タイトル",
        message: "messagemessagemessagemessagemessagemessagemessage",
        positiveButtonTitle: "OK",
        negativeButtonTitle: "NG",
        positiveAction: {},
        negativeAction: {}
    )
}
