//
//  CustomPopUpDialogView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/20.
//

import SwiftUI

struct CustomPopUpDialogView: View {
    @Binding var isPresented: Bool
    public let title: String
    public let message: String

    var body: some View {
        if isPresented {
            ZStack {
                // 画面全体を覆う黒い背景
                Color.black
                    .opacity(0.3)
                    .onTapGesture {
                        // ダイアログ周りタップで閉じる
                        isPresented = false
                    }

                // ポップアップコンテンツ部分
                VStack(spacing: 0) {
                    Text(title)
                        .fontS(bold: true)
                        .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                        .frame(width: DeviceSizeUtility.deviceWidth - 80, alignment: .leading)

                    Rectangle()
                        .frame(width: DeviceSizeUtility.deviceWidth - 80, height: 2)
                        .tint(Asset.Colors.exText.swiftUIColor)
                        .opacity(0.5)
                        .padding(.vertical, 5)

                    ScrollView {
                        Text(message)
                            .fontM(bold: true)
                            .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                            .frame(width: DeviceSizeUtility.deviceWidth - 80, alignment: .leading)
                    }

                }.padding()
                    .frame(width: DeviceSizeUtility.deviceWidth - 40)
                    .frame(maxHeight: DeviceSizeUtility.deviceHeight / 2.5)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .fontL(bold: true)
                                .foregroundStyle(.white)
                                .offset(x: (DeviceSizeUtility.deviceWidth / 2) - 40, y: -DeviceSizeUtility.deviceHeight / 4.5)
                        }
                    }
                // 画面一杯にViewを広げる
            }.font(.system(size: 17))
                .ignoresSafeArea()
        }
    }
}

extension View {
    func popup(
        isPresented: Binding<Bool>,
        title: String,
        message: String
    ) -> some View {
        overlay(
            CustomPopUpDialogView(
                isPresented: isPresented,
                title: title,
                message: message
            )
        )
    }
}

#Preview {
    CustomPopUpDialogView(
        isPresented: Binding.constant(true),
        title: "通知タイトル",
        message: "messagemessagemessagemessagemessagemessagemessage"
    )
}
