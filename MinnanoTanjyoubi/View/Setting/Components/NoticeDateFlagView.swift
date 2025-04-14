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
    @State private var notifyDate: NotifyDate = .onTheDay

    var body: some View {
        Picker("通知日", selection: $notifyDate) {
            ForEach(NotifyDate.allCases, id: \.self) { notifyDate in
                if notifyDate == .onTheDay {
                    Text("当日")
                } else {
                    Text("\(notifyDate.dayNum)日前")
                }
            }
        }.tint(AppColorScheme.getText(rootEnvironment.scheme))
            .fontM()
            .onChange(of: notifyDate) { _ in
                viewModel.registerNotifyDate(flag: notifyDate.rawValue)
            }.onAppear {
                notifyDate = NotifyDate(rawValue: viewModel.getNotifyDate()) ?? .onTheDay
            }
    }
}

struct NoticeDateFlagView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeDateFlagView(viewModel: SettingViewModel())
    }
}
