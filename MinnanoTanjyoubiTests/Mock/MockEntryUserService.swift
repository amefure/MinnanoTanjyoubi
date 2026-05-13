//
//  MockEntryUserService.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2026/05/13.
//
import Foundation
@testable import MinnanoTanjyoubi
import RealmSwift
import Testing

class MockEntryUserService: EntryUserServiceProtocol {
    var fetchUserCalled = 0
    var createUserCalled = 0
    var updateUserCalled = 0
    var getInitDateCalled = 0
    var getInitRelationCalled = 0
    var reloadWidgetsCalled = 0

    var capturedId: ObjectId?
    var capturedCreateState: EntryUserState?
    var capturedUpdateUser: User?
    var capturedUpdateState: EntryUserState?

    // MARK: - スタブ（戻り値の操作）

    var stubbedUser: User = .createDemoUser(
        name: "吉田　真紘",
        ruby: "よしだ　まひろ",
        dateStr: "1994年12月21日",
        relation: .friend
    )
    var stubbedDate = DateComponents(year: 2026, month: 12, day: 15).date!
    var stubbedRelation: MinnanoTanjyoubi.Relation = .friend

    // MARK: - Protocolの実装

    func fetchUser(id: ObjectId) -> User? {
        fetchUserCalled += 1
        capturedId = id
        return stubbedUser
    }

    func createUser(from state: EntryUserState) {
        createUserCalled += 1
        capturedCreateState = state
    }

    func updateUser(_ user: User, from state: EntryUserState) {
        updateUserCalled += 1
        capturedUpdateUser = user
        capturedUpdateState = state
    }

    func getInitDate(month: Int?, day: Int?) -> Date {
        getInitDateCalled += 1
        guard let month, let day else { return stubbedDate }
        return DateComponents(year: 2026, month: month, day: day).date ?? Date()
    }

    func getInitRelation() -> MinnanoTanjyoubi.Relation {
        getInitRelationCalled += 1
        return stubbedRelation
    }

    func reloadWidgets() {
        reloadWidgetsCalled += 1
    }
}
