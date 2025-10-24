//
//  SelectSortViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

final class SelectSortViewModel: ObservableObject {
    @Published private(set) var sort: AppSortItem = .daysLater
    @Published var isShowSuccessAlert: Bool = false

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        getSortItem()
    }

    func setSortItem(sort: AppSortItem) {
        self.sort = sort
    }

    private func getSortItem() {
        sort = userDefaultsRepository.getSortItem()
    }

    /// 並び順登録
    @MainActor
    func registerSortItem() {
        UIApplication.shared.closeKeyboard()
        // カスタムイベント計測
        FBAnalyticsManager.loggingSelectSortEvent(sort: sort)
        userDefaultsRepository.setSortItem(sort)
        getSortItem()
        isShowSuccessAlert = true
    }
}
