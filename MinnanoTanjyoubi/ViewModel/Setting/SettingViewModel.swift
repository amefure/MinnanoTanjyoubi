//
//  SettingViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

/// SettingView画面全域を管理するViewModel
/// 配下のViewも含めて管理
class SettingViewModel: ObservableObject {
    @Published var isShowPassInput: Bool = false
    @Published private(set) var isLock: Bool = false
    @Published private(set) var yearArray: [Int] = []

    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository

    private let dfm = DateFormatUtility()

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository

        setUpYears()
    }

    public func onAppear() {
        checkAppLock()
    }

    private func setUpYears() {
        yearArray = []
        guard let year = dfm.convertDateComponents(date: Date()).year else { return }
        for value in 1900 ... year {
            yearArray.append(value)
        }
        yearArray.sort(by: { $0 > $1 })
    }

    // MARK: - App Lock

    /// アプリにロックがかけてあるかをチェック
    private func checkAppLock() {
        isLock = keyChainRepository.getData().count == 4
    }

    /// パスワード入力画面を表示
    public func showPassInput() {
        isShowPassInput = true
    }

    /// アプリロックパスワードをリセット
    public func deletePassword() {
        keyChainRepository.delete()
    }

    // MARK: - Reward Logic

    // 最大容量取得
    public func getCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
    }

    // MARK: - Notify Logic

    /// 通知時間登録
    public func registerNotifyTime(date: Date) {
        let time = dfm.getTimeString(date: date)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_TIME, value: time)
    }

    /// 通知時間取得
    public func getNotifyTimeDate() -> Date {
        var timeStr = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_TIME)
        if timeStr.isEmpty {
            timeStr = NotifyConfig.INITIAL_TIME
        }
        let timeArray: [Substring] = timeStr.split(separator: "-")
        let hour = Int(timeArray[safe: 0] ?? "6")
        let minute = Int(timeArray[safe: 1] ?? "0")
        return Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
    }

    /// 年数初期値登録
    public func registerEntryInitYear(year: Int) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR, value: year)
    }

    /// 年数初期値取得
    public func getEntryInitYear() -> Int {
        var year = userDefaultsRepository.getIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR)
        if year == 0 {
            guard let nowYear = dfm.convertDateComponents(date: Date()).year else { return 2024 }
            year = nowYear
        }
        return year
    }

    /// 通知日付フラグ登録
    public func registerNotifyDate(flag: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG, value: flag)
    }

    /// 通知日付フラグ取得
    public func getNotifyDate() -> String {
        let flag = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG)
        if flag.isEmpty {
            registerNotifyDate(flag: NotifyConfig.INITIAL_DATE_FLAG)
            return NotifyConfig.INITIAL_DATE_FLAG
        } else {
            return flag
        }
    }

    /// 通知Msg登録
    public func registerNotifyMsg(msg: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_MSG, value: msg)
    }

    /// 通知Msg取得
    public func getNotifyMsg() -> String {
        let msg = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_MSG)
        if msg.isEmpty {
            registerNotifyMsg(msg: NotifyConfig.INITIAL_MSG)
            return NotifyConfig.INITIAL_MSG
        } else {
            return msg
        }
    }

    ///  誕生日までの単位フラグ登録
    public func registerDisplayDaysLater(flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER, isOn: flag)
    }

    /// 誕生日までの単位フラグ取得
    public func getDisplayDaysLater() -> Bool {
        return userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
    }

    /// 年齢に月を含めるかフラグ登録
    public func registerDisplayAgeMonth(flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH, isOn: flag)
    }

    /// 年齢に月を含めるかフラグ取得
    public func getDisplayAgeMonth() -> Bool {
        return userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
    }

    /// チュートリアル再表示フラグセット
    public func setTutorialReShowFlag() {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG, isOn: true)
    }

    /// アプリシェアロジック
    public func shareApp(shareText: String, shareLink: String) {
        ShareInfoUtillity.shareApp(shareText: shareText, shareLink: shareLink)
    }

    /// バージョン番号取得
    public func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
