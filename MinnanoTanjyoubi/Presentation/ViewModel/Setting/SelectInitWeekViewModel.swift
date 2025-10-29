//
//  SelectInitWeekViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

@Observable
final class SelectInitWeekVState {
    private(set) var selectWeek: SCWeek = .sunday
    var isShowSuccessAlert: Bool = false
    fileprivate func setWeek(week: SCWeek) {
        selectWeek = week
    }
}

final class SelectInitWeekViewModel {
    var state = SelectInitWeekVState()

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        getInitWeek()
    }

    func setWeek(week: SCWeek) {
        state.setWeek(week: week)
    }

    private func getInitWeek() {
        state.setWeek(week: userDefaultsRepository.getInitWeek())
    }

    /// 週始まりを登録
    func registerInitWeek() {
        userDefaultsRepository.setInitWeek(state.selectWeek)
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
        state.isShowSuccessAlert = true
    }
}
