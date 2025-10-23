//
//  SelectInitWeekViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

@MainActor
final class SelectInitWeekViewModel: ObservableObject {
    @Published private(set) var selectWeek: SCWeek = .sunday
    @Published var isShowSuccessAlert: Bool = false

    func onAppear() {
        getInitWeek()
    }

    func setWeek(week: SCWeek) {
        selectWeek = week
    }

    private func getInitWeek() {
        selectWeek = AppManager.sharedUserDefaultManager.getInitWeek()
    }

    /// 週始まりを登録
    func registerInitWeek() {
        AppManager.sharedUserDefaultManager.setInitWeek(selectWeek)
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
        isShowSuccessAlert = true
    }
}
