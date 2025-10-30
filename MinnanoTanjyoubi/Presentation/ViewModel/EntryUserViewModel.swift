//
//  EntryUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import RealmSwift
import UIKit

@Observable
final class EntryUserState {
    /// 登録・更新画面で表示するUser情報
    fileprivate var targetUser: User?
    /// ユーザープロパティ
    var name: String = ""
    var ruby: String = ""
    var date: Date = .init()
    var memo: String = ""
    var selectedRelation: Relation = .other
    var isAlert: Bool = true
    var isYearsUnknown: Bool = false
    /// 日付ホイールピッカー表示フラグ
    var showWheel: Bool = false
    /// バリデーションダイアログ
    var isShowValidationDialog: Bool = false

    fileprivate func setUser(_ user: User) {
        targetUser = user
        // Update時なら初期値セット
        name = user.name
        ruby = user.ruby
        date = user.date
        selectedRelation = user.relation
        memo = user.memo
        isYearsUnknown = user.isYearsUnknown
    }
}

final class EntryUserViewModel {
    /// `EntryUserState`
    var state = EntryUserState()

    private let service: EntryUserServiceProtocol

    init(service: EntryUserServiceProtocol) {
        self.service = service
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
            state.date = service.getInitDate(month: isCalendarMonth, day: isCalendarDay)
            // 関係初期値を取得
            state.selectedRelation = service.getInitRelation()
        }
    }

    func onDisappear() {}
}

extension EntryUserViewModel {
    private func fetchTargetUser(id: ObjectId) {
        guard let user: User = service.fetchUser(id: id) else { return }
        state.setUser(user)
    }

    func createOrUpdateUser() -> Bool {
        guard !state.name.isEmpty else {
            state.isShowValidationDialog = true
            return false
        }

        if let targetUser = state.targetUser {
            service.updateUser(targetUser, from: state)
        } else {
            service.createUser(from: state)
        }
        // カレンダー更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)

        return true
    }
}
