//
//  EditNotifyMessageView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/09/16.
//

import SwiftUI

struct EditNotifyMessageView: View {
    @StateObject var viewModel: SettingViewModel

    @State private var notifyMsg = ""
    @State private var isSuccessAlert = false
    @State private var isValidationAlert = false
    @FocusState private var isFocus: Bool

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            UpSideView()

            Text("通知メッセージ編集")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText())
                .fontWeight(.bold)
                .padding(.vertical)

            Text("通知プレビュー")
                .font(.system(size: 14))
                .foregroundStyle(AppColorScheme.getText())
                .fontWeight(.bold)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)

            DemoNotifyView(title: "みんなの誕生日", msg: notifyMsg)

            Rectangle()
                .fill(.white)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)
                .padding(.vertical)

            Text("通知メッセージ入力")
                .font(.system(size: 14))
                .foregroundStyle(AppColorScheme.getText())
                .fontWeight(.bold)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)

            TextField("ここに通知メッセージを入力してね。", text: $notifyMsg)
                .focused($isFocus)
                .padding(20)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 65)
                .fontWeight(.bold)
                .foregroundStyle(AppColorScheme.getFoundationPrimary())
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)

            Text("・通知メッセージは" + NotifyConfig.VARIABLE_USER_NAME + "部分が名前に自動で置き換わります。")
                .font(.system(size: 14))
                .foregroundStyle(AppColorScheme.getText())
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)

            Spacer()

            DownSideView(parentFunction: {
                UIApplication.shared.closeKeyboard()
                guard !notifyMsg.isEmpty else {
                    isValidationAlert = true
                    return
                }
                viewModel.registerNotifyMsg(msg: notifyMsg)
                isSuccessAlert = true
            }, imageString: "checkmark")

            AdMobBannerView()
                .frame(height: 60)

        }.onAppear {
            notifyMsg = viewModel.getNotifyMsg()
            DispatchQueue.main.async {
                isFocus = true
            }
        }.background(AppColorScheme.getFoundationSub())
            .ignoresSafeArea(.keyboard)
            .font(.system(size: 17))
            .navigationBarBackButtonHidden()
            .dialog(
                isPresented: $isSuccessAlert,
                title: "お知らせ",
                message: "通知メッセージを更新しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
            .dialog(
                isPresented: $isValidationAlert,
                title: "お知らせ",
                message: "通知メッセージを入力してください。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    isValidationAlert = false
                }
            )
    }
}

struct DemoNotifyView: View {
    public let title: String
    public let msg: String
    public var time: String = "now"

    /// 名前格納用の変数部分を「お名前」に置換し、その部分の色を変更するメソッド
    private func getAttributedString(_ str: String) -> AttributedString {
        // 変数部分を「お名前」に置換
        let replacedString = str.replacingOccurrences(of: NotifyConfig.VARIABLE_USER_NAME, with: "「お名前」")

        // AttributedStringの初期化
        var attributedString = AttributedString(replacedString)

        // 置換した文字列「お名前」の範囲を取得
        if let range = attributedString.range(of: "「お名前」") {
            // その部分の文字色を変更
            attributedString[range].foregroundColor = AppColorScheme.getThema3()
            attributedString[range].font = .boldSystemFont(ofSize: 13) // サイズは任意で調整
        }

        return attributedString
    }

    var body: some View {
        HStack {
            Asset.Images.appLogo.swiftUIImage
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .font(.system(size: 14))
                        .fontWeight(.bold)

                    Spacer()

                    Text(time)
                        .font(.system(size: 10))
                        .opacity(0.8)
                }

                HStack {
                    Text(getAttributedString(msg))
                        .font(.system(size: 13))
                }
            }
        }.padding()
            .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 65)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray, radius: 3, x: 3, y: 3)
    }
}

#Preview {
    EditNotifyMessageView(viewModel: SettingViewModel())
}
