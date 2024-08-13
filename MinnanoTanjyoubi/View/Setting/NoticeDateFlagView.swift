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
                .opacity(isOn ? 0.9 : 1)
                .background(isOn ? Asset.Colors.themaColor2.swiftUIColor : Asset.Colors.themaColor3.swiftUIColor)
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
