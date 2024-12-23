//
//  DateFormatUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import UIKit

class DateFormatUtility {
    public let df = DateFormatter()
    public let today = Date()
    private let c = Calendar(identifier: .gregorian)

    init() {
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = c
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
    }

    /// 日付を文字列で取得する
    /// yyyy/MM/dd
    public func getSlashString(date: Date) -> String {
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: date)
    }

    /// 日付を文字列で取得する
    /// yyyy年M月d日
    public func getJpString(date: Date) -> String {
        df.dateFormat = "yyyy年M月d日"
        return df.string(from: date)
    }

    /// 西暦：日付を文字列で取得する
    /// Gy年
    public func getJpEraString(date: Date) -> String {
        df.calendar = Calendar(identifier: .japanese)
        df.dateFormat = "Gy年"
        return df.string(from: date)
    }

    /// 通知用：日付を文字列で取得する
    /// yyyy-MM-dd-H-m
    public func getNotifyString(date: Date) -> String {
        df.dateFormat = "yyyy-MM-dd-H-m"
        return df.string(from: date)
    }

    /// 通知用：日付を文字列で取得する
    /// yyyy-MM-dd-H-m
    public func getNotifyDate(from: String) -> Date {
        df.dateFormat = "yyyy-MM-dd-H-m"
        return df.date(from: from) ?? Date()
    }

    /// 日付をDate型で取得する
    /// yyyy/MM/dd
    public func getSlashDate(from: String) -> Date? {
        df.dateFormat = "yyyy/MM/dd"
        return df.date(from: from)
    }

    /// 日付をDate型で取得する
    /// yyyy/MM/dd
    public func getJpDate(from: String) -> Date {
        df.dateFormat = "yyyy年M月d日"
        return df.date(from: from) ?? Date()
    }

    /// 時間をString型で取得する
    /// H-mm
    public func getTimeString(date: Date) -> String {
        df.dateFormat = "H-mm"
        return df.string(from: date)
    }

    /// 月をInt型で取得する
    public func getMonthInt(date: Date) -> Int {
        df.dateFormat = "M"
        let month = df.string(from: date)
        return Int(month) ?? 0
    }
}

// MARK: - 　Calendar

extension DateFormatUtility {
    /// `Date`型を受け取り`DateComponents`型を返す
    /// - Parameters:
    ///   - date: 変換対象の`Date`型
    ///   - components: `DateComponents`で取得したい`Calendar.Component`
    /// - Returns: `DateComponents`
    public func convertDateComponents(date: Date, components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents {
        c.dateComponents(components, from: date)
    }

    /// 指定した年数にしたDateオブジェクトを返す
    public func setYearDate(year: Int) -> Date {
        let now = Date()
        // 現在の時間、分、秒を取得
        let currentMonth = c.component(.month, from: now)
        let currentDay = c.component(.day, from: now)
        let currentHour = c.component(.hour, from: now)
        let currentMinute = c.component(.minute, from: now)
        let currentSecond = c.component(.second, from: now)

        // 指定された年月日と現在の時刻で日付を構成する
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = currentMonth
        dateComponents.day = currentDay
        dateComponents.hour = currentHour
        dateComponents.minute = currentMinute
        dateComponents.second = currentSecond

        return c.date(from: dateComponents) ?? now
    }
}
