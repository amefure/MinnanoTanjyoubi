//
//  SelectInitWeekViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

final class SelectInitWeekViewModel: ObservableObject {
    @Published private(set) var selectWeek: SCWeek = .sunday
    @Published var isShowSuccessAlert: Bool = false

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        getInitWeek()
    }

    func setWeek(week: SCWeek) {
        selectWeek = week
    }

    private func getInitWeek() {
        selectWeek = userDefaultsRepository.getInitWeek()
    }

    /// 週始まりを登録
    func registerInitWeek() {
        userDefaultsRepository.setInitWeek(selectWeek)
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
        isShowSuccessAlert = true
    }
}
