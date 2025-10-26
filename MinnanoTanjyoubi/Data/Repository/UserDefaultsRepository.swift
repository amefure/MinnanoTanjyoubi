//
//  UserDefaultsRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/01.
//

import UIKit

class UserDefaultsKey {
    /// 容量制限
    static let LIMIT_CAPACITY = "LimitCapacity"
    /// 最終視聴日
    static let LAST_ACQUISITION_DATE = "LastAcquisitionDate"
    /// 通知時間「H-mm」形式
    static let NOTICE_TIME = "NoticeTime"
    /// 通知日付フラグ  String型  "0"(当日) or "1"(前日)
    static let NOTICE_DATE_FLAG = "NoticeDate"
    /// 通知MSG
    static let NOTICE_MSG = "NoticeMsg"
    /// 後何日かフラグ
    static let DISPLAY_DAYS_LATER = "DISPLAY_DAYS_LATER"
    /// 年齢に何ヶ月を表示するかどうか
    static let DISPLAY_AGE_MONTH = "DISPLAY_AGE_MONTH"
    /// セクションレイアウト表示フラグ
    static let DISPLAY_SECTION_LAYOUT = "DISPLAY_SECTION_LAYOUT"
    /// 登録年数初期値(INITのTypo)
    static let ENTRY_INTI_YEAR = "ENTRY_INTI_YEAR"
    /// 登録関係初期値
    static let ENTRY_INIT_RELATION = "ENTRY_INIT_RELATION"
    /// アプリカラースキーム
    static let APP_COLOR_SCHEME = "APP_COLOR_SCHEME"
    /// 並び順
    static let APP_SORT_ITEM = "APP_SORT_ITEM"
    /// チュートリアル表示フラグ
    static let TUTORIAL_SHOW_FLAG = "TUTORIAL_SHOW_FLAG"
    /// チュートリアル再表示フラグ
    static let TUTORIAL_RE_SHOW_FLAG = "TUTORIAL_RE_SHOW_FLAG"
    /// レビューポップアップフラグ表示
    static let SHOW_REVIEW_POPUP = "SHOW_REVIEW_POPUP"
    /// レビューポップアップマイグレーションフラグ表示
    static let SHOW_REVIEW_POPUP_MIGRATE_VERSION = "SHOW_REVIEW_POPUP_MIGRATE_VERSION"
    /// アプリ起動回数
    static let LAUNCH_APP_COUNT = "LAUNCH_APP_COUNT"
    /// アプリ内課金：広告削除
    static let PURCHASED_REMOVE_ADS = "PURCHASE_REMOVE_ADS"
    /// アプリ内課金：容量解放
    static let PURCHASED_UNLOCK_STORAGE = "PURCHASED_UNLOCK_STORAGE"
    /// 曜日始まり
    static let INIT_WEEK = "INIT_WEEK"

    /// 関係名をカスタム登録
    static let DISPLAY_RELATION_FRIEND = "DISPLAY_RELATION_FRIEND"
    static let DISPLAY_RELATION_FAMILY = "DISPLAY_RELATION_FAMILY"
    static let DISPLAY_RELATION_SCHOOL = "DISPLAY_RELATION_SCHOOL"
    static let DISPLAY_RELATION_WORK = "DISPLAY_RELATION_WORK"
    static let DISPLAY_RELATION_OTHER = "DISPLAY_RELATION_OTHER"
    static let DISPLAY_RELATION_SNS = "DISPLAY_RELATION_SNS"
}

/// `UserDefaults`の基底クラス
/// スレッドセーフにするため `final class` + `Sendable`準拠
/// `UserDefaults`が`Sendable`ではないがスレッドセーフのため`@unchecked`で無視しておく
final class UserDefaultsRepository: @unchecked Sendable {
    /// `UserDefaults`がスレッドセーフではあるが`Sendable`ではないため`@unchecked`で回避
    private let userDefaults = UserDefaults.standard

    /// Bool：保存
    func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    func getBoolData(key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    /// Int：保存
    func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    func getIntData(key: String) -> Int {
        userDefaults.integer(forKey: key)
    }

    /// String：保存
    func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    func getStringData(key: String, initialValue: String = "") -> String {
        userDefaults.string(forKey: key) ?? initialValue
    }
}

extension UserDefaultsRepository {
    /// 通知関連のユーサー設定情報を全て取得
    func getNotifyUserSetting() -> (msg: String, timeStr: String, dateFlag: String) {
        let msg = getStringData(key: UserDefaultsKey.NOTICE_MSG, initialValue: NotifyConfig.INITIAL_MSG)
        let timeStr = getStringData(key: UserDefaultsKey.NOTICE_TIME, initialValue: NotifyConfig.INITIAL_TIME)
        let dateFlag = getStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG, initialValue: NotifyConfig.INITIAL_DATE_FLAG)
        return (msg, timeStr, dateFlag)
    }

    /// `LAST_ACQUISITION_DATE`
    /// 取得：最終視聴日
    /// `yyyy/MM/dd`形式で日付を保持
    func getAcquisitionDate() -> String {
        getStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE)
    }

    /// 登録：最終視聴日
    /// `yyyy/MM/dd`形式で日付を保持
    func setAcquisitionDate(_ time: String) {
        setStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE, value: time)
    }

    /// `LIMIT_CAPACITY`
    /// 取得：最大容量
    func getCapacity() -> Int {
        let capacity = getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
    }

    /// 登録：最大容量
    func addCapacity() {
        let current = getCapacity()
        let capacity = current + AdsConfig.ADD_CAPACITY
        setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: capacity)
    }

    /// `NOTICE_TIME`
    /// 取得：通知時間
    func getNotifyTimeDate() -> Date {
        var timeStr = getStringData(key: UserDefaultsKey.NOTICE_TIME)
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
        setStringData(key: UserDefaultsKey.NOTICE_TIME, value: time)
    }

    /// `ENTRY_INTI_YEAR`
    /// 取得：年数初期値
    func getEntryInitYear() -> Int {
        let dfm = DateFormatUtility()
        var year = getIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR)
        if year == 0 {
            guard let nowYear = dfm.convertDateComponents(date: Date()).year else { return 2024 }
            year = nowYear
        }
        return year
    }

    /// 登録：年数初期値
    func setEntryInitYear(_ year: Int) {
        setIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR, value: year)
    }

    /// `ENTRY_INIT_RELATION`
    /// 取得：関係初期値
    func getEntryInitRelation() -> Relation {
        let rawValue = getIntData(key: UserDefaultsKey.ENTRY_INIT_RELATION)
        return Relation.getIndexbyRelation(rawValue)
    }

    /// 登録：関係初期値
    func setEntryInitRelation(_ relation: Relation) {
        setIntData(key: UserDefaultsKey.ENTRY_INIT_RELATION, value: relation.relationIndex)
    }

    /// `NOTICE_DATE_FLAG`
    /// 取得：通知日付フラグ
    func getNotifyDate() -> String {
        let flag = getStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG)
        if flag.isEmpty {
            setNotifyDate(NotifyConfig.INITIAL_DATE_FLAG)
            return NotifyConfig.INITIAL_DATE_FLAG
        } else {
            return flag
        }
    }

    /// 登録：通知日付フラグ
    func setNotifyDate(_ flag: String) {
        setStringData(key: UserDefaultsKey.NOTICE_DATE_FLAG, value: flag)
    }

    /// `NOTICE_MSG`
    /// 取得：通知Msg
    func getNotifyMsg() -> String {
        let msg = getStringData(key: UserDefaultsKey.NOTICE_MSG)
        if msg.isEmpty {
            setNotifyMsg(NotifyConfig.INITIAL_MSG)
            return NotifyConfig.INITIAL_MSG
        } else {
            return msg
        }
    }

    /// 登録：通知Msg
    func setNotifyMsg(_ msg: String) {
        setStringData(key: UserDefaultsKey.NOTICE_MSG, value: msg)
    }

    /// `DISPLAY_DAYS_LATER`
    /// 取得：後何日かフラグ
    func getDisplayDaysLater() -> Bool {
        getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
    }

    /// 登録：後何日かフラグ
    func setDisplayDaysLater(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：年齢に何ヶ月を表示するかどうか
    func getDisplayAgeMonth() -> Bool {
        getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
    }

    /// 取得：年齢に何ヶ月を表示するかどうか
    func setDisplayAgeMonth(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：セクショングリッドレイアウト変更フラグ
    func getDisplaySectionLayout() -> LayoutItem {
        let layoutItemInt = getIntData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT)
        return LayoutItem(rawValue: layoutItemInt) ?? LayoutItem.grid
    }

    /// 登録：セクショングリッドレイアウト変更フラグ
    func setDisplaySectionLayout(_ layout: LayoutItem) {
        setIntData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT, value: layout.rawValue)
    }

    /// `APP_COLOR_SCHEME`
    /// 取得：アプリカラースキーム
    func getColorScheme() -> AppColorScheme {
        let color = getStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, initialValue: AppColorScheme.original.rawValue)
        return AppColorScheme(rawValue: color) ?? .original
    }

    /// 登録：アプリカラースキーム
    func setColorScheme(_ scheme: AppColorScheme) {
        setStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, value: scheme.rawValue)
    }

    /// `APP_SORT_ITEM`
    /// 取得：並び順
    func getSortItem() -> AppSortItem {
        let item = getStringData(key: UserDefaultsKey.APP_SORT_ITEM, initialValue: AppSortItem.daysLater.rawValue)
        return AppSortItem(rawValue: item) ?? .daysLater
    }

    /// 登録：並び順
    func setSortItem(_ sort: AppSortItem) {
        setStringData(key: UserDefaultsKey.APP_SORT_ITEM, value: sort.rawValue)
    }

    /// `TUTORIAL_SHOW_FLAG`
    /// 取得： チュートリアル初回表示フラグ
    func getShowTutorialFlag() -> Bool {
        getBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG)
    }

    /// 登録： チュートリアル初回表示フラグ
    func setShowTutorialFlag(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG, isOn: flag)
    }

    /// `TUTORIAL_RE_SHOW_FLAG`
    /// 取得：チュートリアル再表示フラグ
    func getTutorialReShowFlag() -> Bool {
        getBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG)
    }

    /// 登録：チュートリアル再表示フラグ
    func setTutorialReShowFlag(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG, isOn: flag)
    }

    /// `SHOW_REVIEW_POPUP`
    /// 取得：レビューポップアップ表示フラグ
    func getShowReviewPopupFlag() -> Bool {
        getBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP)
    }

    /// 登録：レビューポップアップ表示フラグ
    func setShowReviewPopupFlag(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP, isOn: flag)
    }

    /// `SHOW_REVIEW_POPUP_MIGRATE_VERSION`
    /// 取得：レビューポップアップ表示マイグレーションフラグ
    func getShowReviewPopupMigrateVersion() -> Int {
        getIntData(key: UserDefaultsKey.SHOW_REVIEW_POPUP_MIGRATE_VERSION)
    }

    /// 登録：レビューポップアップ表示マイグレーションフラグ
    func setShowReviewPopupMigrateVersion(_ value: Int) {
        setIntData(key: UserDefaultsKey.SHOW_REVIEW_POPUP_MIGRATE_VERSION, value: value)
    }

    /// `LAUNCH_APP_COUNT`
    /// 取得：アプリ起動回数
    func getLaunchAppCount() -> Int {
        getIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT)
    }

    /// 登録：アプリ起動回数登録
    func setLaunchAppCount(reset: Bool = false) {
        if reset {
            setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: 0)
        } else if getLaunchAppCount() <= 10 {
            // 無限に回数を更新しないように10回で打ち止めにする
            let addCount: Int = getLaunchAppCount() + 1
            setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: addCount)
        }
    }

    /// `PURCHASED_REMOVE_ADS`
    /// 取得：アプリ内課金 / 広告削除
    func getPurchasedRemoveAds() -> Bool {
        getBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS)
    }

    /// 登録：アプリ内課金 / 広告削除
    func setPurchasedRemoveAds(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS, isOn: flag)
    }

    /// `PURCHASED_UNLOCK_STORAGE`
    /// 取得：アプリ内課金 / 容量解放
    func getPurchasedUnlockStorage() -> Bool {
        getBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE)
    }

    /// 登録：アプリ内課金 / 容量解放
    func setPurchasedUnlockStorage(_ flag: Bool) {
        setBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE, isOn: flag)
    }

    /// `INIT_WEEK`
    /// 取得：カレンダー週始まり
    func getInitWeek() -> SCWeek {
        let week = getIntData(key: UserDefaultsKey.INIT_WEEK)
        return SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// 登録：カレンダー週始まり
    func setInitWeek(_ week: SCWeek) {
        setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
}
