//
//  BirthDayWidget.swift
//  BirthDayWidget
//
//  Created by t&a on 2025/09/09.
//

import SwiftUI
import WidgetKit

/// `Widget`を管理する`TimelineProvider`
struct Provider: TimelineProvider {
    /// 仮で表示させたいビュー
    func placeholder(in _: Context) -> BirthDayEntry {
        BirthDayEntry(date: .now, users: [])
    }

    /// 一時的な(最初の)ビュー&Widget Galleryのプレビュー
    func getSnapshot(in _: Context, completion: @escaping (BirthDayEntry) -> Void) {
        let entry = BirthDayEntry(date: .now, users: User.demoUsers)
        completion(entry)
    }

    /// 時間と共に変化させる間隔とビュー
    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let users = BirthDayWidgetViewModel().getAllUser()
        // 現在時刻用の Entry
        let entry = BirthDayEntry(date: currentDate, users: users)
        // 3時間後を次回更新に指定
        guard let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 3, to: currentDate) else { return }

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct BirthDayEntry: TimelineEntry {
    let date: Date
    let users: [User]
}

struct BirthDayWidgetEntryView: View {
    var entry: Provider.Entry

    private let viewModel = BirthDayWidgetViewModel()
    private let dfm = DateFormatUtility()

    /// Widgetサイズを取得
    @Environment(\.widgetFamily) var family

    var body: some View {
        //　WidgetサイズごとにViewを分岐
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        case .systemLarge:
            largeView
        case .systemExtraLarge:
            largeView
        default:
            mediumView
        }
    }

    /// systemSmall
    private var smallView: some View {
        VStack {
            headerView()

            let users = viewModel.getNearBirthDayUser(users: entry.users, size: 4)

            if users.isEmpty {
                emptyDataView()
            } else {
                ForEach(users, id: \.self) { user in
                    HStack(alignment: .center, spacing: 0) {
                        Text(user.name)
                            .fontSS(bold: true)
                            .layoutPriority(1)
                        Spacer()
                        let daysLater = UserCalcUtility.daysLater(from: user.date)
                        if daysLater == 0 {
                            VStack {
                                Text("HAPPY")
                                Text("BIRTHDAY")
                            }.foregroundStyle(.exThemaYellow)
                                .layoutPriority(2)

                        } else {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("あと")
                                Text("\(daysLater)")
                                    .fontS(bold: true)
                                    .foregroundStyle(.exThemaYellow)
                                Text("日")
                            }.layoutPriority(2)
                        }
                    }
                    Spacer()
                }
            }
        }.fontSSS()
            .foregroundStyle(.exText)
    }

    /// systemMedium
    private var mediumView: some View {
        VStack {
            headerView()

            let users = viewModel.getNearBirthDayUser(users: entry.users, size: 4)

            if users.isEmpty {
                emptyDataView()
            } else {
                ForEach(users, id: \.self) { user in
                    HStack(alignment: .center) {
                        Text(user.name)
                            .fontSS(bold: true)
                            .frame(width: 80, alignment: .leading)

                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            if user.isYearsUnknown {
                                Text("-")
                            } else {
                                Text("\(UserCalcUtility.currentAge(from: user.date))")
                                    .fontS()
                                    .foregroundStyle(.exThemaYellow)
                            }
                            Text("歳")
                                .fontSS()
                        }.frame(width: 40, alignment: .leading)

                        if user.isYearsUnknown {
                            Text(dfm.getJpStringOnlyDate(date: user.date))
                                .fontSS()
                        } else {
                            Text(dfm.getJpString(date: user.date))
                                .fontSS()
                        }

                        Spacer()
                        let daysLater = UserCalcUtility.daysLater(from: user.date)
                        if daysLater == 0 {
                            VStack {
                                Text("HAPPY")
                                Text("BIRTHDAY")
                            }.foregroundStyle(.exThemaYellow)

                        } else {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("あと")
                                Text("\(daysLater)")
                                    .fontS(bold: true)
                                    .foregroundStyle(.exThemaYellow)
                                Text("日")
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.fontSSS()
            .foregroundStyle(.exText)
    }

    /// systemLarge
    private var largeView: some View {
        VStack {
            headerView()

            let users = viewModel.getNearBirthDayUser(users: entry.users, size: 8)

            if users.isEmpty {
                emptyDataView()
            } else {
                ForEach(users, id: \.self) { user in
                    HStack(alignment: .center) {
                        Text(user.name)
                            .fontSS(bold: true)
                            .frame(width: 80, alignment: .leading)

                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            if user.isYearsUnknown {
                                Text("-")
                            } else {
                                Text("\(UserCalcUtility.currentAge(from: user.date))")
                                    .fontS()
                                    .foregroundStyle(.exThemaYellow)
                            }
                            Text("歳")
                                .fontSS()
                        }.frame(width: 40, alignment: .leading)

                        if user.isYearsUnknown {
                            Text(dfm.getJpStringOnlyDate(date: user.date))
                                .fontSS()
                        } else {
                            Text(dfm.getJpString(date: user.date))
                                .fontSS()
                        }

                        Spacer()
                        let daysLater = UserCalcUtility.daysLater(from: user.date)
                        if daysLater == 0 {
                            VStack {
                                Text("HAPPY")
                                Text("BIRTHDAY")
                            }.foregroundStyle(.exThemaYellow)

                        } else {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("あと")
                                Text("\(daysLater)")
                                    .fontS(bold: true)
                                    .foregroundStyle(.exThemaYellow)
                                Text("日")
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.fontSSS()
            .foregroundStyle(.exText)
    }

    /// ヘッダービュー
    private func headerView() -> some View {
        VStack {
            HStack {
                appIcon(size: 20)
                Text("みんなの誕生日")
                    .fontSS(bold: true)
            }
            Divider()
        }
    }

    /// データ空
    private func emptyDataView() -> some View {
        VStack {
            Spacer()

            Text("誕生日情報がありません。\nアプリから登録してね♪")
                .fontSS(bold: true)

            Spacer()
        }
    }

    /// アプリアイコン
    private func appIcon(
        size: CGFloat
    ) -> some View {
        Image("Appicon-remove")
            .resizable()
            .frame(width: size, height: size)
            .padding(5)
            .background(.exSchemaBg)
            .clipShape(RoundedRectangle(cornerRadius: size))
    }
}

struct BirthDayWidget: Widget {
    let kind: String = "BirthDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BirthDayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BirthDayWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("みんなの誕生日 Widget")
        .description("誕生日が近い順に登録済みの情報が表示されます。")
    }
}

#Preview(as: .systemSmall) {
    BirthDayWidget()
} timeline: {
    BirthDayEntry(date: .now, users: User.demoUsers)
    BirthDayEntry(date: .now, users: User.demoUsers)
}
