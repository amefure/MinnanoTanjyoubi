//
//  NotificationButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/12/22.
//

import SwiftUI

// MARK: - 通知登録ビュー

struct NotificationButtonView: View {
    // MARK: - Models

    @State var user: User

    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // MARK: - View

    @State var isON: Bool = false

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isSESize = DeviceSizeManager.isSESize

    var body: some View {
        Toggle(isOn: $isON, label: {
            Text("通知")
        }).toggleStyle(SwitchToggleStyle(tint: ColorAsset.themaColor1.thisColor))
            .onChange(of: isON) { newValue in
                if newValue {
                    // 通知を登録
                    let dfm = DateFormatManager()
                    let dateString = dfm.getNotifyString(date: user.date)
                    AppManager.sharedNotificationRequestManager.sendNotificationRequest(user.id, user.name, dateString)

                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: true)
                } else {
                    // 通知を削除
                    AppManager.sharedNotificationRequestManager.removeNotificationRequest(user.id, user.name)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: false)
                }
            }.frame(width: deviceWidth - 60).padding(isSESize ? 5 : 10)
            .onAppear {
                // 初期値セット
                isON = user.alert
            }
    }
}
