//
//  CalendarViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

@preconcurrency import Combine
import UIKit

final class CalendarViewModel: ObservableObject {
    private let dateFormatUtility = DateFormatUtility()

    // MARK: Calendar ロジック

    @Published var currentDates: [[SCDate]] = []
    @Published private(set) var currentYearAndMonth: [SCYearAndMonth] = []
    @Published private(set) var dayOfWeekList: [SCWeek] = []
    /// アプリに表示しているカレンダー年月インデックス番号
    @Published var displayCalendarIndex: CGFloat = 0

    /// 曜日始まり
    @Published private(set) var initWeek: SCWeek = .sunday

    /// カレンダーをイニシャライズしたかどうか
    private var isInitializeFlag: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private var updateCancellable: AnyCancellable?

    /// `Repository`
    private let localRepository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository

    init(
        localRepository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository,
        scCalenderRepository: SCCalenderRepository
    ) {
        self.localRepository = localRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.scCalenderRepository = scCalenderRepository

        getInitWeek()

        dayOfWeekList = setFirstWeek(week: initWeek)

        // 初回描画用に最新月だけ取得して表示する
        let today = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
        let yearAndMonth = SCYearAndMonth(year: today.year ?? 1, month: today.month ?? 1)
        let dates = scCalenderRepository.createDates(yearAndMonth: yearAndMonth, df: dateFormatUtility)
        currentDates = [dates]
        currentYearAndMonth = [yearAndMonth]
    }

    deinit {
        updateCancellable?.cancel()
    }

    func onAppear() {
        if !isInitializeFlag {
            // リフレッシュしたいため都度取得する
            let users: [User] = localRepository.readAllObjs()
            scCalenderRepository.initialize(initWeek: initWeek, users: users)
            isInitializeFlag = true
        }

        scCalenderRepository.displayCalendarIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)

        scCalenderRepository.currentDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                guard let self else { return }
                currentDates = dates
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
                dayOfWeekList = list
            }.store(in: &cancellables)

        // カレンダー更新用Notificationを観測
        updateCancellable = NotificationCenter.default.publisher(for: .updateCalendar)
            .sink { [weak self] notification in
                guard let self else { return }
                guard let obj = notification.object as? Bool else { return }
                // trueなら更新
                if obj {
                    // 週始まりを変更している可能性があるため再取得
                    getInitWeek()
                    // リフレッシュしたいため都度取得する
                    let users: [User] = localRepository.readAllObjs()
                    scCalenderRepository.initialize(initWeek: initWeek, users: users)
                    // カレンダーを更新
                    NotificationCenter.default.post(name: .updateCalendar, object: false)
                }
            }
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - SCCalender

extension CalendarViewModel {
    /// 年月ページを1つ進める
    func forwardMonthPage() {
        let count: Int = currentYearAndMonth.count
        let next = Int(min(displayCalendarIndex + 1, CGFloat(count)))
        scCalenderRepository.setDisplayCalendarIndex(index: next)
        // 最大年月まで2になったら翌月を追加する
        if displayCalendarIndex == CGFloat(count) - 2 {
            addNextMonth()
        }
    }

    /// 年月ページを1つ戻る
    func backMonthPage() {
        if displayCalendarIndex == 2 {
            // 残り年月が2になったら前月を12ヶ月分追加する
            addPreMonth()
            // 2のタイミングで12ヶ月分追加するのでインデックスを+10
            let next = Int(displayCalendarIndex + 10)
            scCalenderRepository.setDisplayCalendarIndex(index: next)
        } else {
            let next = Int(displayCalendarIndex - 1)
            scCalenderRepository.setDisplayCalendarIndex(index: next)
        }
    }

    /// 現在表示中の年月を取得する
    func getCurrentYearAndMonth() -> SCYearAndMonth {
        currentYearAndMonth[safe: Int(displayCalendarIndex)] ?? SCYearAndMonth(year: 2025, month: 1)
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
    func setFirstWeek(week: SCWeek) -> [SCWeek] {
        scCalenderRepository.setFirstWeek(week)
    }

    /// 今月にカレンダーを移動
    func moveTodayCalendar() {
        // 今月の年月を取得
        let (year, month) = dateFormatUtility.getDateYearAndMonth()

        guard let displayYearAndMonth = currentYearAndMonth[safe: Int(displayCalendarIndex)] else { return }
        // 今月を表示しているなら更新しない
        guard displayYearAndMonth.month != month else { return }
        guard let todayIndex = currentYearAndMonth.firstIndex(where: { $0.year == year && $0.month == month }) else { return }
        displayCalendarIndex = CGFloat(todayIndex)
    }

    /// 更新対象のインデックス番号を取得する
    private func getUpdateCurrentDateIndex(createdAt: Date) -> (Int, Int) {
        // 月でフィルタリング
        guard let index = currentYearAndMonth.firstIndex(where: { $0.month == dateFormatUtility.getDateYearAndMonth(date: createdAt).month }) else { return (-1, -1) }
        // 更新対象のSCDateを取得
        guard let index2 = currentDates[index].firstIndex(where: {
            if let date = $0.date {
                dateFormatUtility.checkInSameDayAs(date: date, sameDay: createdAt)
            } else {
                false
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

    /// 容量超過確認
    func isOverCapacity(_ size: Int) -> Bool {
        let users: [User] = localRepository.readAllObjs()
        let size = users.count + size
        return size > userDefaultsRepository.getCapacity()
    }
}
