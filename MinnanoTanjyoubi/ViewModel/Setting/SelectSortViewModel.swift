//
//  SelectSortViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/16.
//

import SwiftUI

@MainActor
final class SelectSortViewModel: ObservableObject {
    @Published private(set) var sort: AppSortItem = .daysLater
    @Published var isShowSuccessAlert: Bool = false

    
    func onAppear() {
        getSortItem()
    }
    
    func setSortItem(sort: AppSortItem) {
        self.sort = sort
    }
    
    private func getSortItem() {
        sort = AppManager.sharedUserDefaultManager.getSortItem()
    }
    
    /// 並び順登録
    func registerSortItem() {
        UIApplication.shared.closeKeyboard()
        // カスタムイベント計測
        FBAnalyticsManager.loggingSelectSortEvent(sort: sort)
        AppManager.sharedUserDefaultManager.setSortItem(sort)
        getSortItem()
        isShowSuccessAlert = true
    }
    
}
