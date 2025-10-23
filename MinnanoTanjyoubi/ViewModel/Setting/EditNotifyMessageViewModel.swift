//
//  EditNotifyMessageViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

@MainActor
final class EditNotifyMessageViewModel: ObservableObject {
    @Published var notifyMsg: String = ""
    @Published var isShowSuccessAlert: Bool = false
    @Published var isShowValidateAlert: Bool = false

    func onAppear() {
        notifyMsg = getNotifyMsg()
        FBAnalyticsManager.loggingScreen(screen: .EditNotifyMessageScreen)
    }

    /// 通知Msg取得
    private func getNotifyMsg() -> String {
        AppManager.sharedUserDefaultManager.getNotifyMsg()
    }

    /// 通知Msg登録
    func registerNotifyMsg() {
        UIApplication.shared.closeKeyboard()
        guard !notifyMsg.isEmpty else {
            isShowValidateAlert = true
            return
        }
        AppManager.sharedUserDefaultManager.setNotifyMsg(notifyMsg)
        isShowSuccessAlert = true
    }
}
