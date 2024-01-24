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
    ///  後何日かフラグ
    static let DISPLAY_DAYS_LATER = "DISPLAY_DAYS_LATER"
    ///  年齢に何ヶ月を表示するかどうか
    static let DISPLAY_AGE_MONTH = "DISPLAY_AGE_MONTH"
    ///  セクションレイアウト表示フラグ
    static let DISPLAY_SECTION_LAYOUT = "DISPLAY_SECTION_LAYOUT"

    ///  関係名をカスタム登録
    static let DISPLAY_RELATION_FRIEND = "DISPLAY_RELATION_FRIEND"
    static let DISPLAY_RELATION_FAMILY = "DISPLAY_RELATION_FAMILY"
    static let DISPLAY_RELATION_SCHOOL = "DISPLAY_RELATION_SCHOOL"
    static let DISPLAY_RELATION_WORK = "DISPLAY_RELATION_WORK"
    static let DISPLAY_RELATION_OTHER = "DISPLAY_RELATION_OTHER"
}

/// UserDefaultsの基底クラス
class UserDefaultsRepository {
    static let sheard = UserDefaultsRepository()

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
