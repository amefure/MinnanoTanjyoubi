//
//  RootListUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/15.
//

import UIKit
import Combine

@MainActor
final class RootListUserViewModel: ObservableObject {
    
    @Published private(set) var allUsers: [User] = []
    /// 上限に達した場合のアラート
    @Published var isShowLimitAlert: Bool = false
    /// 新規登録モーダル表示
    @Published var isShowEntryModal: Bool = false
    /// グリッドレイアウトスクロールダウンフラグ
    @Published var isScrollingDown: Bool = false
    /// コントロールパネルopacity
    @Published var opacity: Double = 1
    
    /// 関係ピッカー表示中かどうか
    @Published var isShowRelationPicker = false
    /// フィルタリング中かどうか
    @Published var isFiltering = false
    /// 選択されたフィルタリング関係
    @Published var selectedFilteringRelation: Relation = .other
    
    private let repository: RealmRepository
    private var cancellables: Set<AnyCancellable> = []

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
    }

    func onAppear() {
        $isScrollingDown
            .sink(receiveValue: { [weak self] flag in
                guard let self else { return }
                // 下方向にスクロール中のみ半透明にする
                self.opacity = self.isScrollingDown ? 0.5 : 1
            }).store(in: &cancellables)
        
        // 登録モーダルから戻った(falseになった)際にはリフレッシュ
        $isShowEntryModal
            .sink { [weak self] flag in
                guard let self else { return }
                guard !flag else { return }
                self.readAllUsers()
            }.store(in: &cancellables)
        
        $selectedFilteringRelation
            .sink { [weak self] newValue in
                guard let self else { return }
                // 変更になったらフィルタリング
                filteringUser(selectedRelation: newValue)
            }.store(in: &cancellables)
        
        readAllUsers()
    }
    
    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
    
    /// iOS18以降かどうか
    var isIos18Later: Bool {
        if #available(iOS 18, *) {
            return true
        } else {
            return false
        }
    }
    
}

extension RootListUserViewModel {
    
    /// データを一度リフレッシュしてからフィルタリング
    private func filteringUser(selectedRelation: Relation) {
        readAllUsers()
        allUsers = allUsers.filter { $0.relation == selectedRelation }
    }
    
    /// 全てのデータをソート順を反映させて取得
    private func readAllUsers(sort: AppSortItem? = nil) {
        var sort: AppSortItem? = sort
        allUsers.removeAll()
        let result: [User] = repository.readAllObjs()
        // 明示的な指定がない場合はローカルに設定しているソートを対象にする
        if sort == nil {
            sort = getSortItem()
        }
        
        let dfmMonthOnly = DateFormatUtility(format: .monthOnly)
        
        switch sort {
        case .daysLater:
            // 誕生日までの日付が近い順にソート
            allUsers = Array(result).sorted(by: {
                UserCalcUtility.daysLater(from: $0.date) < UserCalcUtility.daysLater(from: $1.date)
            })
        case .nameAsce:
            // 名前(昇順)
            allUsers = Array(result).sorted(by: { $0.ruby < $1.ruby })
        case .nameDesc:
            // 名前(降順)
            allUsers = Array(result).sorted(by: { $0.ruby > $1.ruby })
        case .ageAsce:
            // 年齢(昇順)
            allUsers = Array(result).sorted(by: {
                if $0.isYearsUnknown != $1.isYearsUnknown {
                    return !$0.isYearsUnknown && $1.isYearsUnknown
                }
                return UserCalcUtility.currentAge(from: $0.date) < UserCalcUtility.currentAge(from: $1.date)
            })
        case .ageeDesc:
            // 年齢(降順)
            allUsers = Array(result).sorted(by: {
                if $0.isYearsUnknown != $1.isYearsUnknown {
                    return !$0.isYearsUnknown && $1.isYearsUnknown
                }
                return UserCalcUtility.currentAge(from: $0.date) > UserCalcUtility.currentAge(from: $1.date)
            })
        case .montheAsce:
            // 生まれ月(昇順)
            allUsers = Array(result).sorted(by: {
                let pre = dfmMonthOnly.getMonthInt(date: $0.date)
                let late = dfmMonthOnly.getMonthInt(date: $1.date)
                return pre < late
            })
        case .montheDesc:
            // 生まれ月(降順)
            allUsers = Array(result).sorted(by: {
                let pre = dfmMonthOnly.getMonthInt(date: $0.date)
                let late = dfmMonthOnly.getMonthInt(date: $1.date)
                return pre > late
            })
        case .none:
            // 誕生日までの日付が近い順にソート
            allUsers = Array(result).sorted(by: {
                UserCalcUtility.daysLater(from: $0.date) < UserCalcUtility.daysLater(from: $1.date)
            })
        }

        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
    }

    /// 並び順
    private func getSortItem() -> AppSortItem {
        AppManager.sharedUserDefaultManager.getSortItem()
    }
}



extension RootListUserViewModel {
    
    func showSortPickerOrResetFiltering() {
        if isFiltering {
            isFiltering = false
            readAllUsers()
        } else {
            isShowRelationPicker = true
            isFiltering = true
        }
    }
    
    func checkEntryEnabled() {
        let isUnlockStorage = AppManager.sharedUserDefaultManager.getPurchasedUnlockStorage()
        // 容量がオーバーしていないか または 容量解放されている
        if !isOverCapacity(1) || isUnlockStorage {
            // 登録モーダル表示
            isShowEntryModal = true
        } else {
            // 容量オーバーアラート表示
            isShowLimitAlert = true
        }
    }

    /// 容量超過確認
    private func isOverCapacity(_ size: Int) -> Bool {
        let size = allUsers.count + size
        return size > getMaxCapacity()
    }
    
    /// 最大容量取得
    private func getMaxCapacity() -> Int {
        AppManager.sharedUserDefaultManager.getCapacity()
    }
}
