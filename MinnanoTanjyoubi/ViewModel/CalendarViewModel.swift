//
//  CalendarViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import Combine
import UIKit

class CalendarViewModel: ObservableObject {
    static let shared = CalendarViewModel()

    private let dateFormatUtility = DateFormatUtility()

    // MARK: Calendar ロジック

    @Published var currentDates: [[SCDate]] = []
    @Published private(set) var currentYearAndMonth: [SCYearAndMonth] = []
    @Published private(set) var dayOfWeekList: [SCWeek] = []
    /// アプリに表示しているカレンダー年月インデックス番号
    @Published var displayCalendarIndex: CGFloat = 0

    // MARK: 永続化

    @Published private(set) var initWeek: SCWeek = .sunday

    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository

    private var cancellables: Set<AnyCancellable> = []

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository

        getInitWeek()

        setFirstWeek(week: initWeek)
    }

    public func onAppear(users: [User]) {
        scCalenderRepository.initialize(users: users)

        scCalenderRepository.displayCalendarIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                self.displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)

        scCalenderRepository.currentDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                guard let self else { return }
                self.currentDates = dates
            }.store(in: &cancellables)

        scCalenderRepository.currentYearAndMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentYearAndMonth in
                guard let self else { return }
                self.currentYearAndMonth = currentYearAndMonth
            }.store(in: &cancellables)

        scCalenderRepository.dayOfWeekList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                guard let self else { return }
                self.dayOfWeekList = list
            }.store(in: &cancellables)
    }

    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - SCCalender

extension CalendarViewModel {
    /// 年月ページを1つ進める
    public func forwardMonthPage() {
        let count: Int = currentYearAndMonth.count
        displayCalendarIndex = min(displayCalendarIndex + 1, CGFloat(count))
        // 最大年月まで2になったら翌月を追加する
        if displayCalendarIndex == CGFloat(count) - 2 {
            addNextMonth()
        }
    }

    /// 年月ページを1つ戻る
    public func backMonthPage() {
        if displayCalendarIndex == 2 {
            // 残り年月が2になったら前月を12ヶ月分追加する
            addPreMonth()
            // 2のタイミングで12ヶ月分追加するのでインデックスを+10
            displayCalendarIndex = displayCalendarIndex + 10
        } else {
            displayCalendarIndex = displayCalendarIndex - 1
        }
    }

    /// 現在表示中の年月を取得する
    public func getCurrentYearAndMonth() -> SCYearAndMonth {
        return currentYearAndMonth[safe: Int(displayCalendarIndex)] ?? SCYearAndMonth(year: 2025, month: 1)
    }

    /// 格納済みの最新月の翌月を追加する
    private func addNextMonth() {
        _ = scCalenderRepository.addNextMonth()
    }

    /// 格納済みの最古月の前月を12ヶ月分追加する
    private func addPreMonth() {
        _ = scCalenderRepository.addPreMonth()
    }

    /// 週始まりを設定
    public func setFirstWeek(week: SCWeek) {
        scCalenderRepository.setFirstWeek(week)
    }

    /// 今月にカレンダーを移動
    public func moveTodayCalendar() {
        // 今月の年月を取得
        let (year, month) = dateFormatUtility.getDateYearAndMonth()

        guard let displayYearAndMonth = currentYearAndMonth[safe: Int(displayCalendarIndex)] else { return }
        // 今月を表示しているなら更新しない
        guard displayYearAndMonth.month != month else { return }
        guard let todayIndex = currentYearAndMonth.firstIndex(where: { $0.year == year && $0.month == month }) else { return }
        displayCalendarIndex = CGFloat(todayIndex)
    }

//    /// Poopが追加された際にカレンダー構成用のデータも更新
//    public func addPoopUpdateCalender(createdAt: Date) {
//        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
//        if year != -1, date != -1 {
//            currentDates[year][date].count += 1
//        }
//    }
//
//    /// Poopが削除された際にカレンダー構成用のデータも更新
//    public func deletePoopUpdateCalender(createdAt: Date) {
//        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
//        if year != -1, date != -1 {
//            currentDates[year][date].count -= 1
//        }
//    }

    // 更新対象のインデックス番号を取得する
    private func getUpdateCurrentDateIndex(createdAt: Date) -> (Int, Int) {
        // 月でフィルタリング
        guard let index = currentYearAndMonth.firstIndex(where: { $0.month == dateFormatUtility.getDateYearAndMonth(date: createdAt).month }) else { return (-1, -1) }
        // 更新対象のSCDateを取得
        guard let index2 = currentDates[index].firstIndex(where: {
            if let date = $0.date {
                return dateFormatUtility.checkInSameDayAs(date: date, sameDay: createdAt)
            } else {
                return false
            }
        }) else { return (-1, -1) }
        return (index, index2)
    }
}

// MARK: - UserDefaults

extension CalendarViewModel {
    /// 週始まりを取得
    private func getInitWeek() {
        let week = userDefaultsRepository.getIntData(key: UserDefaultsKey.INIT_WEEK)
        initWeek = SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// 週始まりを登録
    public func saveInitWeek(week: SCWeek) {
        initWeek = week
        userDefaultsRepository.setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
}
