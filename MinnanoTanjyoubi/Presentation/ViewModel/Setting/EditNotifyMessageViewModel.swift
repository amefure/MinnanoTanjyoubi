//
//  EditNotifyMessageViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

final class EditNotifyMessageViewModel: ObservableObject {
    @Published var notifyMsg: String = ""
    @Published var isShowSuccessAlert: Bool = false
    @Published var isShowValidateAlert: Bool = false

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        notifyMsg = getNotifyMsg()
        FBAnalyticsManager.loggingScreen(screen: .EditNotifyMessageScreen)
    }

    /// 通知Msg取得
    private func getNotifyMsg() -> String {
        userDefaultsRepository.getNotifyMsg()
    }

    /// 通知Msg登録
    @MainActor
    func registerNotifyMsg() {
        UIApplication.shared.closeKeyboard()
        guard !notifyMsg.isEmpty else {
            isShowValidateAlert = true
            return
        }
        userDefaultsRepository.setNotifyMsg(notifyMsg)
        isShowSuccessAlert = true
    }
}
