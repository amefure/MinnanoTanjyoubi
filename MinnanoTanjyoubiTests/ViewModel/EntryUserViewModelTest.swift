//
//  EntryUserViewModelTest.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2026/05/13.
//

import Foundation
@testable import MinnanoTanjyoubi
import RealmSwift
import Testing

@Suite("EntryUserViewModel テスト")
struct EntryUserViewModelTest {
    private let viewModel: EntryUserViewModel
    private let mockService: MockEntryUserService
    private let mockDispatcher: MockNotificationDispatcher

    init() {
        // テストごとにクリーンな状態のインスタンスを作成
        mockService = MockEntryUserService()
        mockDispatcher = MockNotificationDispatcher()
        viewModel = EntryUserViewModel(
            service: mockService,
            notificationDispatcher: mockDispatcher
        )
    }

    @Test("onAppear：新規登録モードで画面表示時に日付と関係の初期値が格納されること")
    func onAppear_NewEntry_Default() {
        // Arrange
        let expectedDate = DateComponents(year: 2026, month: 12, day: 15).date ?? Date()
        let expectedRelation: MinnanoTanjyoubi.Relation = .friend

        // Act
        viewModel.onAppear(
            updateUserId: nil,
            isCalendarMonth: nil,
            isCalendarDay: nil
        )

        // Assert
        #expect(viewModel.state.date == expectedDate)
        #expect(viewModel.state.selectedRelation == expectedRelation)
        #expect(mockService.fetchUserCalled == 0)
        #expect(mockService.getInitDateCalled == 1)
    }

    @Test("onAppear：カレンダーからの新規登録時、指定した月日がサービスに渡されること")
    func onAppear_NewEntry_FromCalendar() {
        // Arrange
        let expectedDate = DateComponents(year: 2026, month: 5, day: 3).date ?? Date()

        // Act
        // 「5月3日」が指定されたと仮定
        viewModel.onAppear(
            updateUserId: nil,
            isCalendarMonth: 5,
            isCalendarDay: 3
        )
        // Assert
        #expect(viewModel.state.date == expectedDate)
        #expect(mockService.fetchUserCalled == 0)
        #expect(mockService.getInitDateCalled == 1)
    }

    @Test("onAppear：既存ユーザー編集時、ユーザー情報がフェッチされること")
    func onAppear_UpdateUser() {
        // Arrange
        let targetId = ObjectId()

        // Act
        viewModel.onAppear(
            updateUserId: targetId,
            isCalendarMonth: nil,
            isCalendarDay: nil
        )

        // Assert
        #expect(mockService.fetchUserCalled == 1)
        #expect(mockService.capturedId == targetId)
        #expect(viewModel.state.name == mockService.stubbedUser.name)
        #expect(mockService.getInitDateCalled == 0)
        #expect(mockService.getInitRelationCalled == 0)
    }

    @Test("createOrUpdateUser：名前が空の場合、バリデーションダイアログを表示してfalseを返すこと")
    func save_EmptyName_Fails() {
        // Arrange
        // 名前を空にする
        viewModel.state.name = ""

        // Act
        let result = viewModel.createOrUpdateUser()

        // Assert
        #expect(result == false)
        #expect(viewModel.state.isShowValidationDialog == true)
        #expect(mockService.createUserCalled == 0)
        #expect(mockService.updateUserCalled == 0)
        #expect(mockDispatcher.postedNames.isEmpty)
    }

    @Test("createOrUpdateUser：新規登録時、ServiceのcreateUserが呼ばれ、通知が発行されること")
    func save_NewUser_Success() {
        // Arrange
        viewModel.state.name = "新しいユーザー"

        // Act
        let result = viewModel.createOrUpdateUser()

        // Assert
        #expect(result == true)
        #expect(mockService.createUserCalled == 1)
        #expect(mockService.capturedCreateState?.name == "新しいユーザー")
        #expect(mockDispatcher.postedNames.contains(.readAllUsers))
        #expect(mockDispatcher.postedNames.contains(.updateCalendar))
    }

    @Test("createOrUpdateUser：更新時、ServiceのupdateUserが呼ばれ、詳細画面更新の通知も発行されること")
    func save_UpdateUser_Success() {
        // Arrange
        let targetId = ObjectId()
        viewModel.onAppear(
            updateUserId: targetId,
            isCalendarMonth: nil,
            isCalendarDay: nil
        )
        viewModel.state.name = "更新後の名前"

        // Act
        let result = viewModel.createOrUpdateUser()

        // Assert
        #expect(result == true)
        #expect(mockService.updateUserCalled == 1)
        #expect(mockService.capturedCreateState?.name == "更新後の名前")
        #expect(mockDispatcher.postedNames.contains(.readAllUsers))
        #expect(mockDispatcher.postedNames.contains(.updateCalendar))
    }
}
