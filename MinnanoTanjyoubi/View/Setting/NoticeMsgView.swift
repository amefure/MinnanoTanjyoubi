//
//  NoticeMsgView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/24.
//

import SwiftUI

struct NoticeMsgView: View {
    // MARK: - ViewModel

    @StateObject var viewModel: SettingViewModel

    // MARK: - View

    @State private var text = ""
    @State private var isEdit: Bool = false
    @FocusState private var isFocusActive: Bool

    /// 名前格納用の変数部分の色を変換するメソッド
    private func getAttributedString(_ str: String) -> AttributedString {
        var attributedString = AttributedString(str)

        if let range = attributedString.range(of: NotifyConfig.VARIABLE_USER_NAME) {
            attributedString[range].foregroundColor = ColorAsset.themaColor3.thisColor
        }
        return attributedString
    }

    var body: some View {
        HStack {
            if isEdit {
                TextField("Message...", text: $text)
                    .onChange(of: text) { newValue in
                        viewModel.registerNotifyMsg(msg: newValue)
                    }.foregroundColor(ColorAsset.themaColor1.thisColor)
                    .focused($isFocusActive)
            } else {
                Text(getAttributedString(text))
            }
            Spacer()
            Button {
                isEdit.toggle()
                isFocusActive = true
            } label: {
                Text(isEdit ? "更新" : "編集").font(.none)
            }.padding(5)
                .frame(width: 55)
                .background(isEdit ? ColorAsset.themaColor1.thisColor : ColorAsset.foundationColorLight.thisColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .opacity(0.7)

        }.onAppear {
            text = viewModel.getNotifyMsg()
        }.font(DeviceSizeManager.isSESize ? .caption : .none)
    }
}

struct NoticeMsgView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeMsgView(viewModel: SettingViewModel())
    }
}
