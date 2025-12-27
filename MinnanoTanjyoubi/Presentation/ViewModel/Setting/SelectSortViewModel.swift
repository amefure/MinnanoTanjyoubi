//
//  SelectSortViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

@Observable
final class SelectSortState {
    private(set) var sort: AppSortItem = .daysLater
    var isShowSuccessAlert: Bool = false
    fileprivate func setSortItem(sort: AppSortItem) {
        self.sort = sort
    }
}

final class SelectSortViewModel {
    var state = SelectSortState()

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        getSortItem()
    }

    func setSortItem(sort: AppSortItem) {
        state.setSortItem(sort: sort)
    }

    private func getSortItem() {
        state.setSortItem(sort: userDefaultsRepository.getSortItem())
    }

    /// 並び順登録
    @MainActor
    func registerSortItem() {
        UIApplication.shared.closeKeyboard()
        // カスタムイベント計測
        FBAnalyticsManager.loggingSelectSortEvent(sort: state.sort)
        userDefaultsRepository.setSortItem(state.sort)
        getSortItem()
        state.isShowSuccessAlert = true
        // 並び順を反映
        NotificationCenter.default.post(name: .readAllUsers, object: true)
    }
}
