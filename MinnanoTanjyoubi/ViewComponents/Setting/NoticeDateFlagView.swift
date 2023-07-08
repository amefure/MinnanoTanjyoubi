//
//  NoticeDateFlagView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/21.
//

import SwiftUI

struct NoticeDateFlagView: View {
    @State var isOn: Bool = true

    // MARK: - Storage

    @AppStorage("NoticeDate") var noticeTime: String = "0"

    var body: some View {
        HStack {
            Text("通知日")
            Spacer()
            Toggle(isOn: $isOn) {
                Text(isOn ? "当日" : "前日")
            }.toggleStyle(.button)
                .background(isOn ? ColorAsset.themaColor2.thisColor : ColorAsset.themaColor3.thisColor)
                .opacity(isOn ? 0.8 : 1)
                .cornerRadius(5)
                .onChange(of: isOn) { newValue in
                    if newValue {
                        noticeTime = "0"
                    } else {
                        noticeTime = "1"
                    }
                }
        }
    }
}

struct NoticeDateFlagView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeDateFlagView()
    }
}
