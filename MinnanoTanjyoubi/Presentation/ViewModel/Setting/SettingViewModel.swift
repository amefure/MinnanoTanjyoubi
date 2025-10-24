//
//  SettingViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import Combine
import UIKit

/// SettingView画面全域を管理するViewModel
/// 配下のViewも含めて管理
final class SettingViewModel: ObservableObject {
    @Published var isShowPassInput: Bool = false
    @Published var isShowInAppPurchaseView: Bool = false

    @Published private(set) var yearArray: [Int] = []

    @Published var isDaysLaterFlag: Bool = false
    @Published var isAgeMonthFlag: Bool = false
    @Published var isLock: Bool = false
    @Published var selectedNotifyDate: NotifyDate = .onTheDay
    @Published var selectedRelation: Relation = .other
    @Published var selectedYear: Int = 2025

    private var allUsers: [User] = []

    private let dfm = DateFormatUtility()
    private var cancellables: Set<AnyCancellable> = []

    /// `Repository`
    private let repository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let keyChainRepository: KeyChainRepository

    init(
        repository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository,
        keyChainRepository: KeyChainRepository
    ) {
        self.repository = repository
        self.userDefaultsRepository = userDefaultsRepository
        self.keyChainRepository = keyChainRepository

        setUpYears()
    }

    func onAppear() {
        setUpIsLock()
        setUpDisplayAgeMonth()
        setUpDaysLaterFlag()
        setUpNotifyDate()
        setUpEntryInitRelation()
        setUpEntryInitYear()
        allUsers = repository.readAllObjs()
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

extension SettingViewModel {
    var allUserCount: Int {
        allUsers.count
    }

    /// アプリロック
    private func setUpIsLock() {
        isLock = keyChainRepository.getData().count == 4
        $isLock
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] flag in
                guard let self else { return }
                if flag {
                    // パスワード入力画面を表示
                    self.isShowPassInput = true
                } else {
                    // アプリパスワードをリセット
                    self.keyChainRepository.delete()
                }
            }.store(in: &cancellables)
    }

    /// 年齢の月数表示
    private func setUpDisplayAgeMonth() {
        isAgeMonthFlag = getDisplayAgeMonth()
        $isAgeMonthFlag
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] flag in
                self?.registerDisplayAgeMonth(flag: flag)
            }.store(in: &cancellables)
    }

    /// 誕生日までの単位
    private func setUpDaysLaterFlag() {
        isDaysLaterFlag = getDisplayDaysLater()
        $isDaysLaterFlag
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] flag in
                self?.registerDisplayDaysLater(flag: flag)
            }.store(in: &cancellables)
    }

    /// 通知日
    private func setUpNotifyDate() {
        selectedNotifyDate = NotifyDate(rawValue: getNotifyDate()) ?? .onTheDay
        $selectedNotifyDate
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] flag in
                self?.registerNotifyDate(flag: flag.rawValue)
            }.store(in: &cancellables)
    }

    /// 関係初期値セットアップ
    private func setUpEntryInitRelation() {
        selectedRelation = getEntryInitRelation()
        $selectedRelation
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] relation in
                self?.registerEntryInitRelation(relation: relation)
            }.store(in: &cancellables)
    }

    /// 年数初期値セットアップ
    private func setUpEntryInitYear() {
        selectedYear = getEntryInitYear()
        $selectedYear
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] year in
                self?.registerEntryInitYear(year: year)
            }.store(in: &cancellables)
    }

    /// 登録可能年数ピッカー用値セット
    private func setUpYears() {
        yearArray = []
        guard let year = dfm.convertDateComponents(date: Date()).year else { return }
        for value in 1900 ... year {
            yearArray.append(value)
        }
        yearArray.sort(by: { $0 > $1 })
    }

    // MARK: - Reward Logic

    // 最大容量取得
    func getCapacity() -> Int {
        userDefaultsRepository.getCapacity()
    }

    // MARK: - Notify Logic

    /// 通知時間取得
    func getNotifyTimeDate() -> Date {
        userDefaultsRepository.getNotifyTimeDate()
    }

    /// 通知時間登録
    func registerNotifyTime(date: Date) {
        userDefaultsRepository.setNotifyTimeDate(date)
    }

    /// 年数初期値取得
    private func getEntryInitYear() -> Int {
        userDefaultsRepository.getEntryInitYear()
    }

    /// 年数初期値登録
    private func registerEntryInitYear(year: Int) {
        userDefaultsRepository.setEntryInitYear(year)
    }

    /// 年数初期値取得
    private func getEntryInitRelation() -> Relation {
        userDefaultsRepository.getEntryInitRelation()
    }

    /// 年数初期値登録
    private func registerEntryInitRelation(relation: Relation) {
        userDefaultsRepository.setEntryInitRelation(relation)
    }

    ///  通知日付フラグ取得
    private func getNotifyDate() -> String {
        userDefaultsRepository.getNotifyDate()
    }

    /// 通知日付フラグ登録
    private func registerNotifyDate(flag: String) {
        userDefaultsRepository.setNotifyDate(flag)
    }

    ///  誕生日までの単位フラグ登録
    private func registerDisplayDaysLater(flag: Bool) {
        userDefaultsRepository.setDisplayDaysLater(flag)
    }

    /// 誕生日までの単位フラグ取得
    private func getDisplayDaysLater() -> Bool {
        return userDefaultsRepository.getDisplayDaysLater()
    }

    /// 年齢に月を含めるかフラグ登録
    private func registerDisplayAgeMonth(flag: Bool) {
        userDefaultsRepository.setDisplayAgeMonth(flag)
    }

    /// 年齢に月を含めるかフラグ取得
    private func getDisplayAgeMonth() -> Bool {
        return userDefaultsRepository.getDisplayAgeMonth()
    }

    /// チュートリアル再表示フラグセット
    func setTutorialReShowFlag() {
        userDefaultsRepository.setTutorialReShowFlag(true)
    }

    /// アプリシェアロジック
    @MainActor
    func shareApp(shareText: String, shareLink: String) {
        ShareInfoUtillity.shareApp(shareText: shareText, shareLink: shareLink)
    }

    /// バージョン番号取得
    func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
