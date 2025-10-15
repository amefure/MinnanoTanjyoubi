//
//  EntryUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import UIKit
import Combine
import RealmSwift
import WidgetKit

@MainActor
final class EntryUserViewModel: ObservableObject {
    
    /// 登録・更新画面で表示するUser情報
    @Published var targetUser: User? = nil
    
    /// プロパティ
    @Published var name: String = ""
    @Published var ruby: String = ""
    @Published var date: Date = Date()
    @Published var memo: String = ""
    @Published var selectedRelation: Relation = .other
    @Published var isAlert: Bool = true
    @Published var isYearsUnknown: Bool = false
    
    /// カレンダーON/OFF
    @Published var showWheel: Bool = false
    /// バリデーションダイアログ
    @Published var isShowValidationDialog: Bool = false
    
    private let repository: RealmRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
    }
    
    func onAppear(
        updateUserId: ObjectId?,
        isCalendarMonth: Int?,
        isCalendarDay: Int?
    ) {
        
        if let updateUserId {
            //
            fetchTargetUser(id: updateUserId)
        } else {
            // 新規登録なら初期値年数を反映
            // カレンダーからの遷移なら日付まで指定する
            date = getInitDate(month: isCalendarMonth, day: isCalendarDay)
            // 関係初期値を取得
            selectedRelation = getInitRelation()
        }
    }

    func onDisappear() {
    }
}

extension EntryUserViewModel {
    
    private func fetchTargetUser(id: ObjectId) {
        guard let user: User = repository.getByPrimaryKey(id) else { return }
        targetUser = user
        // Update時なら初期値セット
        name = user.name
        ruby = user.ruby
        date = user.date
        selectedRelation = user.relation
        memo = user.memo
        isYearsUnknown = user.isYearsUnknown
    }
    
    
    func createOrUpdateUser() -> Bool {
        guard !name.isEmpty else {
            isShowValidationDialog = true
            return false
        }
        
        if let targetUser {
            // Update
            repository.updateObject(User.self, id: targetUser.id) { [weak self] obj in
                guard let self else { return }
                obj.name = self.name
                obj.ruby = self.ruby
                obj.date = self.date
                obj.relation = self.selectedRelation
                obj.memo = self.memo
                obj.alert = self.isAlert
                obj.isYearsUnknown = self.isYearsUnknown
            }
        } else {
            let newUser = User()
            newUser.name = name
            newUser.ruby = ruby
            newUser.date = date
            newUser.relation = selectedRelation
            newUser.memo = memo
            newUser.alert = isAlert
            newUser.isYearsUnknown = isYearsUnknown
            // Create
            if isAlert {
                AppManager.sharedNotificationRequestManager.sendNotificationRequest(newUser.id, name, date)
            }
            repository.createObject(newUser)
        }
        
        // 登録 & 更新のタイミングでウィジェットも更新する
        WidgetCenter.shared.reloadAllTimelines()
        return true
    }

    /// 保存された年数&カレンダーから渡された日付があればそのDateオブジェクトを取得
    private func getInitDate(month: Int?, day: Int?) -> Date {
        let dfm = DateFormatUtility()
        let year = AppManager.sharedUserDefaultManager.getEntryInitYear()
        let yearDate = dfm.setDate(year: year, month: month, day: day)
        return yearDate
    }

    /// 関係初期値
    private func getInitRelation() -> Relation {
        return AppManager.sharedUserDefaultManager.getEntryInitRelation()
    }
}
