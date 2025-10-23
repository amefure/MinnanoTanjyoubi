//
//  SCCalenderRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import Combine
import SwiftUI

final class SCCalenderRepository: @unchecked Sendable {
    // MARK: Config

    // 初期表示位置デモ値
    static let START_YEAR = 2023
    static let START_MONTH = 1
    /// 最初に表示したい曜日
    private var initWeek: SCWeek = .sunday

    /// 表示対象として保持している日付オブジェクト
    /// `currentYearAndMonth`の要素番号と紐づく形で日付情報が格納される
    ///  `[[2月の日付情報] , [3月の日付情報] , [4月の日付情報]]`
    var currentDates: AnyPublisher<[[SCDate]], Never> {
        _currentDates.eraseToAnyPublisher()
    }

    private let _currentDates = CurrentValueSubject<[[SCDate]], Never>([])

    /// 表示対象として保持している年月オブジェクト
    ///  `[2024.2 , 2024.3 , 2024.4]`
    /// `forwardMonth / backMonth`を実行するたびに追加されていく
    /// 初期表示時点は
    var currentYearAndMonth: AnyPublisher<[SCYearAndMonth], Never> {
        _currentYearAndMonth.eraseToAnyPublisher()
    }

    private let _currentYearAndMonth = CurrentValueSubject<[SCYearAndMonth], Never>([])

    /// 表示している曜日配列(順番はUIに反映される)
    var dayOfWeekList: AnyPublisher<[SCWeek], Never> {
        _dayOfWeekList.eraseToAnyPublisher()
    }

    private let _dayOfWeekList = CurrentValueSubject<[SCWeek], Never>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])

    /// アプリに表示中の年月インデックス
    var displayCalendarIndex: AnyPublisher<Int, Never> {
        _displayCalendarIndex.eraseToAnyPublisher()
    }

    private let _displayCalendarIndex = CurrentValueSubject<Int, Never>(0)

    /// 当日の日付情報
    private let today: DateComponents

    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)

    /// 当日の日付情報
    private var users: [User] = []

    init() {
        today = calendar.dateComponents([.year, .month, .day], from: Date())
    }

    func initialize(
        startYear: Int = START_YEAR,
        startMonth: Int = START_MONTH,
        initWeek: SCWeek = .sunday,
        users: [User]
    ) {
        self.initWeek = initWeek
        self.users = users

        let nowYear: Int = today.year ?? startYear
        let nowMonth: Int = today.month ?? startMonth

        // カレンダーの初期表示用データのセットアップ
        initialSetUpCalendarData(year: nowYear, month: nowMonth)
        // 週の始まりに設定する曜日を指定
        _ = setFirstWeek(initWeek)
        // カレンダー更新
        updateCalendar()
    }
}

// MARK: Private

extension SCCalenderRepository {
    /// カレンダー初期格納年月を指定して更新（前後rangeヶ月分を含める）
    /// - Parameters:
    ///   - year: 当日の指定年
    ///   - month: 中央となる指定月
    ///   - range: 中央を基準に前後に含める月数（例: range = 1なら前後1ヶ月ずつ）
    private func initialSetUpCalendarData(year: Int, month: Int, range: Int = 5) {
        let middle = SCYearAndMonth(year: year, month: month)
        var yearAndMonths: [SCYearAndMonth] = []

        let dateComponents = DateComponents(year: middle.year, month: middle.month)
        // 範囲内の前後SCYearAndMonthを生成して追加
        for offset in -range ... range {
            guard let newDate = calendar.date(from: dateComponents),
                  let targetDate = calendar.date(byAdding: .month, value: offset, to: newDate) else { continue }
            let components = calendar.dateComponents([.year, .month], from: targetDate)
            guard let y = components.year,
                  let m = components.month else { continue }
            yearAndMonths.append(SCYearAndMonth(year: y, month: m))
        }

        // 中央に指定しているインデックス番号を取得
        let index: Int = yearAndMonths.firstIndex(where: { $0.yearAndMonth == middle.yearAndMonth }) ?? 0
        _displayCalendarIndex.send(index)

        _currentYearAndMonth.send(yearAndMonths)
    }
}

extension SCCalenderRepository {
    /// カレンダーUIを更新
    /// `currentYearAndMonth`を元に日付情報を取得して配列に格納
    func updateCalendar() {
        let yearAndMonths = _currentYearAndMonth.value

        let df = DateFormatUtility()

        var datesList: [[SCDate]] = []
        for yearAndMonth in yearAndMonths {
            let dates: [SCDate] = createDates(yearAndMonth: yearAndMonth, df: df)
            datesList.append(dates)
        }
        _currentDates.send(datesList)
    }

    /// 1ヶ月単位のSCDateインスタンスを作成
    func createDates(
        yearAndMonth: SCYearAndMonth,
        df: DateFormatUtility
    ) -> [SCDate] {
        let year: Int = yearAndMonth.year
        let month: Int = yearAndMonth.month

        // 指定された年月の最初の日を取得
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let startDate = calendar.date(from: components) else {
            return []
        }

        // 指定された年月の日数を取得
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return []
        }

        // 日にち情報を格納する配列を準備
        var dates: [SCDate] = []

        // 月の初めから最後の日までループして日にち情報を作成
        for day in 1 ... range.count {
            components.year = year
            components.month = month
            components.day = day
            guard let date = calendar.date(from: components) else {
                return []
            }
            let dayOfWeek = calendar.component(.weekday, from: date)
            let week = SCWeek(rawValue: dayOfWeek - 1) ?? SCWeek.sunday
            let isToday: Bool = df.checkInSameDayAs(date: date, sameDay: Date())
            // 対象の日付に紐づく誕生日情報だけを格納する
            let theDayUsers: [User] = users.filter {
                let userComponents = calendar.dateComponents([.month, .day], from: $0.date)
                return day == userComponents.day && month == userComponents.month
            }
            let scDate = SCDate(
                year: year,
                month: month,
                day: day,
                date: date,
                week: week,
                users: theDayUsers,
                isToday: isToday
            )
            dates.append(scDate)
        }

        guard let week = dates.first?.week else { return [] }

        let firstWeek: Int = _dayOfWeekList.value.firstIndex(of: week) ?? 0
        let initWeek: Int = _dayOfWeekList.value.firstIndex(of: initWeek) ?? 0
        let subun: Int = abs(firstWeek - initWeek)

        // 月始まりの曜日より前にブランクを追加
        if subun != 0 {
            for _ in 0 ..< subun {
                let blankScDate = SCDate(year: -1, month: -1, day: -1)
                dates.insert(blankScDate, at: 0)
            }
        }

        // 月終わりの曜日より後にブランクを追加
        if dates.count % 7 != 0 {
            let space = 7 - dates.count % 7
            for _ in 0 ..< space {
                let blankScDate = SCDate(year: -1, month: -1, day: -1)
                dates.append(blankScDate)
            }
        }

        // 35より小さい(5段しかない)なら6段になるように追加
        if dates.count <= 35 {
            for _ in 0 ..< 7 {
                let blankScDate = SCDate(year: -1, month: -1, day: -1)
                dates.append(blankScDate)
            }
        }
        return dates
    }
}

extension SCCalenderRepository {
    /// 格納済みの最新月の翌月を1ヶ月分追加する
    /// - Returns: 成功フラグ
    func addNextMonth() -> Bool {
        var value = _currentYearAndMonth.value
        guard let last = value.last else { return false }
        if last.month + 1 == 13 {
            value.append(SCYearAndMonth(year: last.year + 1, month: 1))
        } else {
            value.append(SCYearAndMonth(year: last.year, month: last.month + 1))
        }
        _currentYearAndMonth.send(value)
        updateCalendar()
        return true
    }

    /// 格納済みの最古月の前月を12ヶ月分追加する
    /// - Returns: 成功フラグ
    func addPreMonth() -> Bool {
        var value = _currentYearAndMonth.value
        // 12ヶ月分一気に追加する
        for _ in 1 ..< 12 {
            guard let first = value.first else { return false }
            if first.month - 1 == 0 {
                value.insert(SCYearAndMonth(year: first.year - 1, month: 12), at: 0)
            } else {
                value.insert(SCYearAndMonth(year: first.year, month: first.month - 1), at: 0)
            }
        }
        _currentYearAndMonth.send(value)
        updateCalendar()
        return true
    }

    /// 最初に表示したい曜日を設定
    /// - parameter week: 開始曜日
    func setFirstWeek(_ week: SCWeek) -> [SCWeek] {
        initWeek = week
        var list = _dayOfWeekList.value
        list.moveWeekToFront(initWeek)
        _dayOfWeekList.send(list)
        updateCalendar()
        return list
    }

    /// カレンダー表示年月インデックスを変更
    func setDisplayCalendarIndex(index: Int) {
        _displayCalendarIndex.send(index)
    }
}
