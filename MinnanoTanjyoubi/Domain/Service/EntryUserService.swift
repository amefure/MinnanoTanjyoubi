//
//  EntryUserService.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/23.
//

import Foundation
import RealmSwift
import WidgetKit

protocol EntryUserServiceProtocol {
    func fetchUser(id: ObjectId) -> User?
    func createUser(from state: EntryUserState)
    func updateUser(_ user: User, from state: EntryUserState)
    func getInitDate(month: Int?, day: Int?) -> Date
    func getInitRelation() -> Relation
    func reloadWidgets()
}

final class EntryUserService: EntryUserServiceProtocol {
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

    func fetchUser(id: ObjectId) -> User? {
        repository.getByPrimaryKey(id)
    }

    func createUser(from state: EntryUserState) {
        let newUser = User()
        newUser.name = state.name
        newUser.ruby = state.ruby
        newUser.date = state.date
        newUser.relation = state.selectedRelation
        newUser.memo = state.memo
        newUser.alert = state.isAlert
        newUser.isYearsUnknown = state.isYearsUnknown

        if state.isAlert {
            let setting = userDefaultsRepository.getNotifyUserSetting()
            notificationRequestManager.sendNotificationRequest(
                id: newUser.id,
                userName: state.name,
                date: state.date,
                msg: setting.msg,
                timeStr: setting.timeStr,
                dateFlag: setting.dateFlag
            )
        }

        repository.createObject(newUser)
        reloadWidgets()
    }

    func updateUser(_ user: User, from state: EntryUserState) {
        repository.updateObject(User.self, id: user.id) { obj in
            obj.name = state.name
            obj.ruby = state.ruby
            obj.date = state.date
            obj.relation = state.selectedRelation
            obj.memo = state.memo
            obj.alert = state.isAlert
            obj.isYearsUnknown = state.isYearsUnknown
        }
        reloadWidgets()
    }

    func getInitDate(month: Int?, day: Int?) -> Date {
        let dfm = DateFormatUtility()
        let year = userDefaultsRepository.getEntryInitYear()
        return dfm.setDate(year: year, month: month, day: day)
    }

    func getInitRelation() -> Relation {
        userDefaultsRepository.getEntryInitRelation()
    }

    func reloadWidgets() {
        widgetCenter.reloadAllTimelines()
    }
}
