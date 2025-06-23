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

    private let dfm = DateFormatUtility()

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository

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
        AppManager.sharedUserDefaultManager.getCapacity()
    }

    // MARK: - Notify Logic

    /// 通知時間取得
    public func getNotifyTimeDate() -> Date {
        AppManager.sharedUserDefaultManager.getNotifyTimeDate()
    }

    /// 通知時間登録
    public func registerNotifyTime(date: Date) {
        AppManager.sharedUserDefaultManager.setNotifyTimeDate(date)
    }

    /// 年数初期値取得
    public func getEntryInitYear() -> Int {
        AppManager.sharedUserDefaultManager.getEntryInitYear()
    }

    /// 年数初期値登録
    public func registerEntryInitYear(year: Int) {
        AppManager.sharedUserDefaultManager.setEntryInitYear(year)
    }

    ///  通知日付フラグ取得
    public func getNotifyDate() -> String {
        AppManager.sharedUserDefaultManager.getNotifyDate()
    }

    /// 通知日付フラグ登録
    public func registerNotifyDate(flag: String) {
        AppManager.sharedUserDefaultManager.setNotifyDate(flag)
    }

    /// 通知Msg取得
    public func getNotifyMsg() -> String {
        AppManager.sharedUserDefaultManager.getNotifyMsg()
    }

    /// 通知Msg登録
    public func registerNotifyMsg(msg: String) {
        AppManager.sharedUserDefaultManager.setNotifyMsg(msg)
    }

    ///  誕生日までの単位フラグ登録
    public func registerDisplayDaysLater(flag: Bool) {
        AppManager.sharedUserDefaultManager.setDisplayDaysLater(flag)
    }

    /// 誕生日までの単位フラグ取得
    public func getDisplayDaysLater() -> Bool {
        return AppManager.sharedUserDefaultManager.getDisplayDaysLater()
    }

    /// 年齢に月を含めるかフラグ登録
    public func registerDisplayAgeMonth(flag: Bool) {
        AppManager.sharedUserDefaultManager.setDisplayAgeMonth(flag)
    }

    /// 年齢に月を含めるかフラグ取得
    public func getDisplayAgeMonth() -> Bool {
        return AppManager.sharedUserDefaultManager.getDisplayAgeMonth()
    }

    /// チュートリアル再表示フラグセット
    public func setTutorialReShowFlag() {
        AppManager.sharedUserDefaultManager.setTutorialReShowFlag(true)
    }

    /// アプリシェアロジック
    @MainActor
    public func shareApp(shareText: String, shareLink: String) {
        ShareInfoUtillity.shareApp(shareText: shareText, shareLink: shareLink)
    }

    /// バージョン番号取得
    public func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
