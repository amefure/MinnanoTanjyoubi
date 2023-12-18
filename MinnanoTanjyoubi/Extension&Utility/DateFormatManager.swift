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

    /// 日付をDate型で取得する
    /// yyyy/MM/dd
    public func getSlashDate(from: String) -> Date? {
        df.dateFormat = "yyyy/MM/dd"
        return df.date(from: from)
    }
}