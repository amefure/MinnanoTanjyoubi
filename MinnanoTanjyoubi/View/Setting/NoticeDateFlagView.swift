//
//  NoticeDateFlagView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/21.
//

import SwiftUI

struct NoticeDateFlagView: View {
    // MARK: - ViewModel

    @StateObject var viewModel: SettingViewModel

    // MARK: - View

    @State private var isOn: Bool = true

    var body: some View {
        HStack {
            Text("通知日")
            Spacer()
            Toggle(isOn: $isOn) {
                Text(isOn ? "当日" : "前日")
            }.toggleStyle(.button)
                .background(isOn ? ColorAsset.themaColor2.thisColor : ColorAsset.themaColor3.thisColor)
                .opacity(isOn ? 0.8 : 1)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onChange(of: isOn) { newValue in
                    if newValue {
                        viewModel.registerNotifyDate(flag: "0")
                    } else {
                        viewModel.registerNotifyDate(flag: "1")
                    }
                }.onAppear {
                    let flag = viewModel.getNotifyDate()
                    isOn = flag == "0"
                }
        }
    }
}

struct NoticeDateFlagView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeDateFlagView(viewModel: SettingViewModel())
    }
}
