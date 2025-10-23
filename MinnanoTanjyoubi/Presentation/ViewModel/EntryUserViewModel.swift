//
//  EntryUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import RealmSwift
import UIKit

struct EntryUserState {
    var name: String = ""
    var ruby: String = ""
    var date: Date = .init()
    var memo: String = ""
    var selectedRelation: Relation = .other
    var isAlert: Bool = true
    var isYearsUnknown: Bool = false
}

final class EntryUserViewModel: ObservableObject {
    /// 登録・更新画面で表示するUser情報
    private var targetUser: User?

    /// `EntryUserState`
    @Published var state = EntryUserState()

    /// カレンダーON/OFF
    @Published var showWheel: Bool = false
    /// バリデーションダイアログ
    @Published var isShowValidationDialog: Bool = false

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
            service.updateUser(targetUser, from: state)
        } else {
            service.createUser(from: state)
        }
        // カレンダー更新
        NotificationCenter.default.post(name: .updateCalendar, object: true)

        return true
    }
}
