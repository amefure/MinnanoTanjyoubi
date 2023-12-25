//
//  DateManagerModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import UIKit

class DateFormatManager {
    public let df = DateFormatter()
    public let today = Date()

    init() {
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
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
}
