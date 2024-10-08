//
//  NoticeDateFlagView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/21.
//

import SwiftUI

struct NoticeDateFlagView: View {
    @StateObject var viewModel: SettingViewModel
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isOn: Bool = true

    var body: some View {
        HStack {
            Text("通知日")
            Spacer()
            Toggle(isOn: $isOn) {
                Text(isOn ? "当日" : "前日")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }.toggleStyle(.button)
                .opacity(isOn ? 0.9 : 1)
                .background(isOn ? AppColorScheme.getThema2(rootEnvironment.scheme) : AppColorScheme.getThema3(rootEnvironment.scheme))
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
