//
//  CalendarViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

@preconcurrency import Combine
import SCCalendar
import UIKit

@Observable
final class CalendarState {
    /// カレンダー表示の年月
    fileprivate(set) var yearAndMonths: [SCYearAndMonth] = []
    /// 曜日リスト
    fileprivate(set) var dayOfWeekList: [SCWeek] = []
    /// アプリに表示しているカレンダー年月インデックス番号
    fileprivate(set) var displayCalendarIndex: CGFloat = 0
    /// 曜日始まり
    fileprivate(set) var initWeek: SCWeek = .sunday
}

final class CalendarViewModel {
    private let dateFormatUtility = DateFormatUtility()

    let state = CalendarState()

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

        state.dayOfWeekList = setFirstWeek(week: state.initWeek)

        // 初回描画用に最新月だけ取得して表示する
        state.yearAndMonths = scCalenderRepository.fetchInitYearAndMonths()
    }

    deinit {
        updateCancellable?.cancel()
    }

    func onAppear() {
        if !isInitializeFlag {
            // リフレッシュしたいため都度取得する
            let users: [User] = localRepository.readAllObjs()
            scCalenderRepository.initialize(initWeek: state.initWeek, entities: users)
            isInitializeFlag = true
        }

        scCalenderRepository.displayCalendarIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                state.displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)

        scCalenderRepository.yearAndMonths
            .receive(on: DispatchQueue.main)
            .sink { [weak self] yearAndMonths in
                guard let self else { return }
                state.yearAndMonths = yearAndMonths
            }.store(in: &cancellables)

        scCalenderRepository.dayOfWeekList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                guard let self else { return }
                state.dayOfWeekList = list
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
                    scCalenderRepository.initialize(initWeek: state.initWeek, entities: users)
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
        scCalenderRepository.forwardMonthPage()
    }

    /// 年月ページを1つ戻る
    func backMonthPage() {
        scCalenderRepository.backMonthPage()
    }

    /// 現在表示中の年月を取得する
    func getCurrentYearAndMonth() -> SCYearAndMonth {
        state.yearAndMonths[safe: Int(state.displayCalendarIndex)] ?? SCYearAndMonth(year: 2025, month: 1, dates: [])
    }

    /// 週始まりを設定
    func setFirstWeek(week: SCWeek) -> [SCWeek] {
        scCalenderRepository.setFirstWeek(week)
    }

    /// 今月にカレンダーを移動
    func moveTodayCalendar() {
        scCalenderRepository.moveTodayCalendar()
    }
}

// MARK: - UserDefaults

extension CalendarViewModel {
    /// 週始まりを取得
    private func getInitWeek() {
        state.initWeek = userDefaultsRepository.getInitWeek()
    }

    /// 容量超過確認
    func isOverCapacity(_ size: Int) -> Bool {
        let users: [User] = localRepository.readAllObjs()
        let size = users.count + size
        return size > userDefaultsRepository.getCapacity()
    }
}
