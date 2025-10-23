//
//  UserDefaultManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/29.
//

import Foundation

final class UserDefaultManager: Sendable {
    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    /// `LAST_ACQUISITION_DATE`
    /// 取得：最終視聴日
    /// `yyyy/MM/dd`形式で日付を保持
    func getAcquisitionDate() -> String {
        userDefaultsRepository.getStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE)
    }

    /// 登録：最終視聴日
    /// `yyyy/MM/dd`形式で日付を保持
    func setAcquisitionDate(_ time: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE, value: time)
    }

    /// `LIMIT_CAPACITY`
    /// 取得：最大容量
    func getCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
    }

    /// 登録：最大容量
    func addCapacity() {
        let current = getCapacity()
        let capacity = current + AdsConfig.ADD_CAPACITY
        userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: capacity)
    }

    /// `NOTICE_TIME`
    /// 取得：通知時間
    func getNotifyTimeDate() -> Date {
        var timeStr = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_TIME)
        if timeStr.isEmpty {
            timeStr = NotifyConfig.INITIAL_TIME
        }
        let timeArray: [Substring] = timeStr.split(separator: "-")
        let hour = Int(timeArray[safe: 0] ?? "6")
        let minute = Int(timeArray[safe: 1] ?? "0")
        return Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
    }

    /// 登録：通知時間
    func setNotifyTimeDate(_ date: Date) {
        let dfm = DateFormatUtility(format: .time)
        let time = dfm.getString(date: date)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_TIME, value: time)
    }

    /// `ENTRY_INTI_YEAR`
    /// 取得：年数初期値
    func getEntryInitYear() -> Int {
        let dfm = DateFormatUtility()
        var year = userDefaultsRepository.getIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR)
        if year == 0 {
            guard let nowYear = dfm.convertDateComponents(date: Date()).year else { return 2024 }
            year = nowYear
        }
        return year
    }

    /// 登録：年数初期値
    func setEntryInitYear(_ year: Int) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR, value: year)
    }

    /// `ENTRY_INIT_RELATION`
    /// 取得：関係初期値
    func getEntryInitRelation() -> Relation {
        let rawValue = userDefaultsRepository.getIntData(key: UserDefaultsKey.ENTRY_INIT_RELATION)
        return Relation.getIndexbyRelation(rawValue)
    }

    /// 登録：関係初期値
    func setEntryInitRelation(_ relation: Relation) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.ENTRY_INIT_RELATION, value: relation.relationIndex)
    }

    /// `NOTICE_DATE_FLAG`
    /// 取得：通知日付フラグ
    func getNotifyDate() -> String {
        let flag = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG)
        if flag.isEmpty {
            setNotifyDate(NotifyConfig.INITIAL_DATE_FLAG)
            return NotifyConfig.INITIAL_DATE_FLAG
        } else {
            return flag
        }
    }

    /// 登録：通知日付フラグ
    func setNotifyDate(_ flag: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG, value: flag)
    }

    /// `NOTICE_MSG`
    /// 取得：通知Msg
    func getNotifyMsg() -> String {
        let msg = userDefaultsRepository.getStringData(key: UserDefaultsKey.NOTICE_MSG)
        if msg.isEmpty {
            setNotifyMsg(NotifyConfig.INITIAL_MSG)
            return NotifyConfig.INITIAL_MSG
        } else {
            return msg
        }
    }

    /// 登録：通知Msg
    func setNotifyMsg(_ msg: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.NOTICE_MSG, value: msg)
    }

    /// `DISPLAY_DAYS_LATER`
    /// 取得：後何日かフラグ
    func getDisplayDaysLater() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
    }

    /// 登録：後何日かフラグ
    func setDisplayDaysLater(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：年齢に何ヶ月を表示するかどうか
    func getDisplayAgeMonth() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
    }

    /// 取得：年齢に何ヶ月を表示するかどうか
    func setDisplayAgeMonth(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：セクショングリッドレイアウト変更フラグ
    func getDisplaySectionLayout() -> LayoutItem {
        let layoutItemInt = userDefaultsRepository.getIntData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT)
        return LayoutItem(rawValue: layoutItemInt) ?? LayoutItem.grid
    }

    /// 登録：セクショングリッドレイアウト変更フラグ
    func setDisplaySectionLayout(_ layout: LayoutItem) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT, value: layout.rawValue)
    }

    /// `APP_COLOR_SCHEME`
    /// 取得：アプリカラースキーム
    func getColorScheme() -> AppColorScheme {
        let color = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, initialValue: AppColorScheme.original.rawValue)
        return AppColorScheme(rawValue: color) ?? .original
    }

    /// 登録：アプリカラースキーム
    func setColorScheme(_ scheme: AppColorScheme) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, value: scheme.rawValue)
    }

    /// `APP_SORT_ITEM`
    /// 取得：並び順
    func getSortItem() -> AppSortItem {
        let item = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_SORT_ITEM, initialValue: AppSortItem.daysLater.rawValue)
        return AppSortItem(rawValue: item) ?? .daysLater
    }

    /// 登録：並び順
    func setSortItem(_ sort: AppSortItem) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_SORT_ITEM, value: sort.rawValue)
    }

    /// `TUTORIAL_SHOW_FLAG`
    /// 取得： チュートリアル初回表示フラグ
    func getShowTutorialFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG)
    }

    /// 登録： チュートリアル初回表示フラグ
    func setShowTutorialFlag(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG, isOn: flag)
    }

    /// `TUTORIAL_RE_SHOW_FLAG`
    /// 取得：チュートリアル再表示フラグ
    func getTutorialReShowFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG)
    }

    /// 登録：チュートリアル再表示フラグ
    func setTutorialReShowFlag(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG, isOn: flag)
    }

    /// `SHOW_REVIEW_POPUP`
    /// 取得：レビューポップアップ表示フラグ
    func getShowReviewPopupFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP)
    }

    /// 登録：レビューポップアップ表示フラグ
    func setShowReviewPopupFlag(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP, isOn: flag)
    }

    /// `SHOW_REVIEW_POPUP_MIGRATE_VERSION`
    /// 取得：レビューポップアップ表示マイグレーションフラグ
    func getShowReviewPopupMigrateVersion() -> Int {
        userDefaultsRepository.getIntData(key: UserDefaultsKey.SHOW_REVIEW_POPUP_MIGRATE_VERSION)
    }

    /// 登録：レビューポップアップ表示マイグレーションフラグ
    func setShowReviewPopupMigrateVersion(_ value: Int) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.SHOW_REVIEW_POPUP_MIGRATE_VERSION, value: value)
    }

    /// `LAUNCH_APP_COUNT`
    /// 取得：アプリ起動回数
    func getLaunchAppCount() -> Int {
        userDefaultsRepository.getIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT)
    }

    /// 登録：アプリ起動回数登録
    func setLaunchAppCount(reset: Bool = false) {
        if reset {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: 0)
        } else if getLaunchAppCount() <= 10 {
            // 無限に回数を更新しないように10回で打ち止めにする
            let addCount: Int = getLaunchAppCount() + 1
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: addCount)
        }
    }

    /// `PURCHASED_REMOVE_ADS`
    /// 取得：アプリ内課金 / 広告削除
    func getPurchasedRemoveAds() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS)
    }

    /// 登録：アプリ内課金 / 広告削除
    func setPurchasedRemoveAds(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS, isOn: flag)
    }

    /// `PURCHASED_UNLOCK_STORAGE`
    /// 取得：アプリ内課金 / 容量解放
    func getPurchasedUnlockStorage() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE)
    }

    /// 登録：アプリ内課金 / 容量解放
    func setPurchasedUnlockStorage(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE, isOn: flag)
    }

    /// `INIT_WEEK`
    /// 取得：カレンダー週始まり
    func getInitWeek() -> SCWeek {
        let week = userDefaultsRepository.getIntData(key: UserDefaultsKey.INIT_WEEK)
        return SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// 登録：カレンダー週始まり
    func setInitWeek(_ week: SCWeek) {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
}
