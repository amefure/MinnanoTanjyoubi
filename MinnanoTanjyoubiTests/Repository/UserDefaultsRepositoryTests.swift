//
//  UserDefaultsRepositoryTests.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2026/04/02.
//

import Foundation
@testable import MinnanoTanjyoubi
import Testing

/// テスト用のモック
final class MockDataSource: UserDefaultsDataSourceProtocol, @unchecked Sendable {
    var storage: [String: Any] = [:]

    func set(_ value: Any?, forKey key: String) { storage[key] = value }
    func bool(forKey key: String) -> Bool { storage[key] as? Bool ?? false }
    func integer(forKey key: String) -> Int { storage[key] as? Int ?? 0 }
    func string(forKey key: String) -> String? { storage[key] as? String }
}

@Suite("UserDefaultsRepository 全網羅テスト")
struct UserDefaultsRepositoryTests {
    let mock: MockDataSource
    let repository: UserDefaultsRepository

    init() {
        // テストごとにクリーンな状態のインスタンスを作成
        mock = MockDataSource()
        repository = UserDefaultsRepository(dataSource: mock)
    }

    // MARK: - 日付・視聴関連

    @Test("最終視聴日の取得と保存")
    func acquisitionDate() {
        let date = "2026/04/01"
        repository.setAcquisitionDate(date)
        #expect(repository.getAcquisitionDate() == date)
    }

    // MARK: - 容量ロジック (AdsConfig依存)

    @Test("容量(Capacity)のロジック: 初期値と加算")
    func capacityLogic() {
        // 未設定時は初期値が返り、かつ保存される
        let initial = repository.getCapacity()
        #expect(initial == AdsConfig.INITIAL_CAPACITY)

        // 加算処理
        repository.addCapacity()
        #expect(repository.getCapacity() == initial + AdsConfig.ADD_CAPACITY)
    }

    // MARK: - 通知関連 (NotifyConfig依存)

    @Test("通知時間(Date)のパース処理")
    func notifyTimeParsing() {
        // 正常系
        mock.set("21-45", forKey: UserDefaultsKey.NOTICE_TIME)
        let date = repository.getNotifyTimeDate()
        let comp = Calendar.current.dateComponents([.hour, .minute], from: date)
        #expect(comp.hour == 21)
        #expect(comp.minute == 45)
    }

    @Test("通知時間(Date)の異常系テスト: 空文字や不正な形式のハンドリング")
    func notifyTimeAnomalySystem() {
        // 1. 空文字の場合：NotifyConfig.INITIAL_TIME (仮に "06-00" とする) が適用されるか
        mock.set("", forKey: UserDefaultsKey.NOTICE_TIME)
        let defaultDate = repository.getNotifyTimeDate()

        let comp = Calendar.current.dateComponents([.hour, .minute], from: defaultDate)

        #expect(comp.hour == 6)
        #expect(comp.minute == 0)

        // 2. 不正な形式（ハイフンがない等）の場合：フォールバックが効くか
        mock.set("invalid_format", forKey: UserDefaultsKey.NOTICE_TIME)
        let fallbackDate = repository.getNotifyTimeDate()
        let fallbackComp = Calendar.current.dateComponents([.hour, .minute], from: fallbackDate)

        #expect(fallbackComp.hour == 6)
        #expect(fallbackComp.minute == 0)

        // 3. 数字ではない文字列の場合
        mock.set("AA-BB", forKey: UserDefaultsKey.NOTICE_TIME)
        let nanDate = repository.getNotifyTimeDate()
        let nanComp = Calendar.current.dateComponents([.hour, .minute], from: nanDate)

        #expect(nanComp.hour == 6)
        #expect(nanComp.minute == 0)
    }

    @Test("通知設定のタプル一括取得")
    func notifyUserSetting() {
        repository.setNotifyMsg("Test Msg")
        repository.setNotifyDate("1")

        let settings = repository.getNotifyUserSetting()
        #expect(settings.msg == "Test Msg")
        #expect(settings.dateFlag == "1")
    }

    // MARK: - 初期値設定関連 (Relation/Year)

    @Test("年数初期値のロジック: 未設定時は現在の年")
    func entryInitYear() {
        repository.setEntryInitYear(2030)
        #expect(repository.getEntryInitYear() == 2030)

        // 0(未設定)の場合は現在年（2026など）が返る
        mock.set(0, forKey: UserDefaultsKey.ENTRY_INTI_YEAR)
        #expect(repository.getEntryInitYear() >= 2024)
    }

    @Test("関係性初期値の保存")
    func entryInitRelation() {
        let relation = MinnanoTanjyoubi.Relation.friend
        repository.setEntryInitRelation(relation)
        #expect(repository.getEntryInitRelation().id == relation.id)
    }

    // MARK: - 表示フラグ・レイアウト

    @Test("各種表示フラグのBoolテスト")
    func displayFlags() {
        // 後何日フラグ
        repository.setDisplayDaysLater(true)
        #expect(repository.getDisplayDaysLater() == true)

        // 年齢月表示
        repository.setDisplayAgeMonth(true)
        #expect(repository.getDisplayAgeMonth() == true)
    }

    @Test("レイアウト・スキーム・ソートのEnumテスト")
    func enumPersistence() {
        repository.setDisplaySectionLayout(.grid)
        #expect(repository.getDisplaySectionLayout() == .grid)

        // カラースキーム
        repository.setColorScheme(.dark)
        #expect(repository.getColorScheme() == .dark)

        // ソート順
        repository.setSortItem(.ageAsce)
        #expect(repository.getSortItem() == .ageAsce)
    }

    // MARK: - 起動回数 (境界値テスト)

    @Test("起動回数のインクリメントと上限(10回)の検証")
    func launchCountBoundary() {
        repository.setLaunchAppCount(reset: true)
        #expect(repository.getLaunchAppCount() == 0)

        // 10回まで加算
        for i in 1 ... 10 {
            repository.setLaunchAppCount()
            #expect(repository.getLaunchAppCount() == i)
        }

        // 11回目を試みても10のまま
        repository.setLaunchAppCount()
        #expect(repository.getLaunchAppCount() == 10)
    }

    // MARK: - アプリ内課金フラグ

    @Test("課金フラグの保存")
    func purchaseFlags() {
        repository.setPurchasedRemoveAds(true)
        #expect(repository.getPurchasedRemoveAds() == true)

        repository.setPurchasedUnlockStorage(true)
        #expect(repository.getPurchasedUnlockStorage() == true)
    }

    // MARK: - カレンダー・関係性名

    @Test("週始まり曜日の保存")
    func initWeek() {
        repository.setInitWeek(.monday)
        #expect(repository.getInitWeek() == .monday)
    }

    @Test("カスタム関係性名のリスト取得")
    func relationNames() {
        // 特定の関係性を書き換え
        repository.setRelationName(key: .friend, value: "マブダチ")

        let list = repository.getRelationNameList()
        #expect(list.contains("マブダチ"))
        #expect(list.count == 6) // 全ての項目が含まれているか
    }
}
