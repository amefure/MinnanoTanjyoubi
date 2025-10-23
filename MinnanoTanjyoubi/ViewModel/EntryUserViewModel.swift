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

struct EntryUserState {
    var name: String = ""
    var ruby: String = ""
    var date: Date = Date()
    var memo: String = ""
    var selectedRelation: Relation = .other
    var isAlert: Bool = true
    var isYearsUnknown: Bool = false
}

final class EntryUserViewModel: ObservableObject {
    
    /// 登録・更新画面で表示するUser情報
    private var targetUser: User? = nil
    
    /// `EntryUserState`
    @Published var state = EntryUserState()
    
    /// カレンダーON/OFF
    @Published var showWheel: Bool = false
    /// バリデーションダイアログ
    @Published var isShowValidationDialog: Bool = false
    
    private let repository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let notificationRequestManager: NotificationRequestManager
    private let widgetCenter: WidgetCenterProtocol

    init(
        repository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository,
        notificationRequestManager: NotificationRequestManager,
        widgetCenter: WidgetCenterProtocol
    ) {
        self.repository = repository
        self.userDefaultsRepository = userDefaultsRepository
        self.notificationRequestManager = notificationRequestManager
        self.widgetCenter = widgetCenter
    }
    
    func onAppear(
        updateUserId: ObjectId?,
        isCalendarMonth: Int?,
        isCalendarDay: Int?
    ) {
        
        if let updateUserId {
            fetchTargetUser(id: updateUserId)
        } else {
            // 新規登録なら初期値年数を反映
            // カレンダーからの遷移なら日付まで指定する
            state.date = getInitDate(month: isCalendarMonth, day: isCalendarDay)
            // 関係初期値を取得
            state.selectedRelation = getInitRelation()
        }
    }

    func onDisappear() { }
}

extension EntryUserViewModel {
    
    private func fetchTargetUser(id: ObjectId) {
        guard let user: User = repository.getByPrimaryKey(id) else { return }
        targetUser = user
        // Update時なら初期値セット
        state.name = user.name
        state.ruby = user.ruby
        state.date = user.date
        state.selectedRelation = user.relation
        state.memo = user.memo
        state.isYearsUnknown = user.isYearsUnknown
    }
    
    
    func createOrUpdateUser() -> Bool {
        guard !state.name.isEmpty else {
            isShowValidationDialog = true
            return false
        }
        
        if let targetUser {
            // Update
            repository.updateObject(User.self, id: targetUser.id) { [weak self] obj in
                guard let self else { return }
                obj.name = self.state.name
                obj.ruby = self.state.ruby
                obj.date = self.state.date
                obj.relation = self.state.selectedRelation
                obj.memo = self.state.memo
                obj.alert = self.state.isAlert
                obj.isYearsUnknown = self.state.isYearsUnknown
            }
        } else {
            let newUser = User()
            newUser.name = state.name
            newUser.ruby = state.ruby
            newUser.date = state.date
            newUser.relation = state.selectedRelation
            newUser.memo = state.memo
            newUser.alert = state.isAlert
            newUser.isYearsUnknown = state.isYearsUnknown
            // Create
            if state.isAlert {
                let setting = userDefaultsRepository.getNotifyUserSetting()
                // 通知を登録
                notificationRequestManager
                    .sendNotificationRequest(
                        id: newUser.id,
                        userName: state.name,
                        date: state.date,
                        msg: setting.msg,
                        timeStr: setting.timeStr,
                        dateFlag: setting.dateFlag
                    )
            }
            repository.createObject(newUser)
        }
        
        // カレンダー更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)
        
        // 登録 & 更新のタイミングでウィジェットも更新する
        widgetCenter.reloadAllTimelines()
        return true
    }

    /// 保存された年数&カレンダーから渡された日付があればそのDateオブジェクトを取得
    private func getInitDate(month: Int?, day: Int?) -> Date {
        let dfm = DateFormatUtility()
        let year = userDefaultsRepository.getEntryInitYear()
        let yearDate = dfm.setDate(year: year, month: month, day: day)
        return yearDate
    }

    /// 関係初期値
    private func getInitRelation() -> Relation {
        return userDefaultsRepository.getEntryInitRelation()
    }
}
