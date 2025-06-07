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
    /// 登録年数初期値
    static let ENTRY_INTI_YEAR = "ENTRY_INTI_YEAR"
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

/// UserDefaultsの基底クラス
class UserDefaultsRepository {
    private let userDefaults = UserDefaults.standard

    /// Bool：保存
    public func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    public func getBoolData(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Int：保存
    public func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    public func getIntData(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }

    /// String：保存
    public func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    public func getStringData(key: String, initialValue: String = "") -> String {
        return userDefaults.string(forKey: key) ?? initialValue
    }
}
