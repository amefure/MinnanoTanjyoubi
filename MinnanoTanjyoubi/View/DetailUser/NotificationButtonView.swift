//
//  NotificationButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/12/22.
//

import SwiftUI

/// 通知登録ビュー
struct NotificationButtonView: View {
    @State var user: User

    // Repository
    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // View
    @State private var isON = false

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

    var body: some View {
        Toggle(isOn: $isON, label: {
            Text("通知")
        }).toggleStyle(SwitchToggleStyle(tint: AppColorScheme.getThema1()))
            .onChange(of: isON) { newValue in
                if newValue {
                    // 通知を登録
                    AppManager.sharedNotificationRequestManager.sendNotificationRequest(user.id, user.name, user.date)

                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: true)
                } else {
                    // 通知を削除
                    AppManager.sharedNotificationRequestManager.removeNotificationRequest(user.id)
                    // データベース更新
                    repository.updateNotifyUser(id: user.id, notify: false)
                }
            }
            .font(.system(size: 17))
            .frame(width: deviceWidth - 60)
            .padding(isSESize ? 5 : 10)
            .onAppear {
                // 初期値セット
                isON = user.alert
            }
    }
}
