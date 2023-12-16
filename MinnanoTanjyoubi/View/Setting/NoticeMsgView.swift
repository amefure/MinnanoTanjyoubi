//
//  NoticeMsgView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/24.
//

import SwiftUI

struct NoticeMsgView: View {
    // MARK: - Storage

    @AppStorage("NoticeMsg") var noticeMsg: String = "今日は{userName}さんの誕生日！"

    @State var text = ""
    @State var isEdit: Bool = false
    @FocusState var isFocusActive: Bool

    private let isSESize: Bool = DeviceSizeManager.isSESize

    private func getAttributedString(_ str: String) -> AttributedString {
        var attributedString = AttributedString(str)

        if let range = attributedString.range(of: "{userName}") {
            attributedString[range].foregroundColor = ColorAsset.themaColor3.thisColor
        }
        return attributedString
    }

    var body: some View {
        HStack {
            if isEdit {
                TextField("Message...", text: $text)
                    .onChange(of: text) { newValue in
                        noticeMsg = newValue
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
                .cornerRadius(5)
                .opacity(0.7)

        }.onAppear {
            text = noticeMsg
        }.font(isSESize ? .caption : .none)
    }
}

struct NoticeMsgView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeMsgView()
    }
}
