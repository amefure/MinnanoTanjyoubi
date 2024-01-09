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
    /// リワードボタン用
    @Published var isAlertReward: Bool = false

    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    public func onAppear() {
        checkAppLock()
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

    // 容量追加
    public func addCapacity() {
        let current = getCapacity()
        let capacity = current + AdsConfig.ADD_CAPACITY
        userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: capacity)
    }

    // 容量取得
    public func getCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
    }

    /// 最終視聴日登録
    public func registerAcquisitionDate() {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE, value: nowTime())
    }

    /// 最終視聴日取得
    public func getAcquisitionDate() -> String {
        userDefaultsRepository.getStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE)
    }

    /// 最終視聴日チェック
    public func checkAcquisitionDate() -> Bool {
        // 格納してある日付と違えばtrue
        getAcquisitionDate() != nowTime()
    }

    /// 登録する視聴日
    private func nowTime() -> String {
        let dfm = DateFormatManager()
        return dfm.getSlashString(date: Date())
    }

    // MARK: - Notify Logic

    /// 通知時間登録
    public func registerNotifyTime(date: Date) {
        let dfm = DateFormatManager()
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

    // MARK: - Share Logic

    /// アプリシェアロジック
    public func shareApp(shareText: String, shareLink: String) {
        let items = [shareText, URL(string: shareLink)!] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popPC = activityVC.popoverPresentationController {
                popPC.sourceView = activityVC.view
                popPC.barButtonItem = .none
                popPC.sourceRect = activityVC.accessibilityFrame
            }
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true, completion: {})
    }
}
