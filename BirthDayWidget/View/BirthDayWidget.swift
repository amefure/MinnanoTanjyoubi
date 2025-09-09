//
//  BirthDayWidget.swift
//  BirthDayWidget
//
//  Created by t&a on 2025/09/09.
//

import SwiftUI
import WidgetKit

// `Widget`を管理する`TimelineProvider`
///
struct Provider: TimelineProvider {
    /// 仮で表示させたいビュー
    func placeholder(in _: Context) -> BirthDayEntry {
        BirthDayEntry(date: Date(), users: [])
    }

    /// 一時的な(最初の)ビュー&Widget Galleryのプレビュー
    func getSnapshot(in _: Context, completion: @escaping (BirthDayEntry) -> Void) {
        let entry = BirthDayEntry(date: Date(), users: [])
        completion(entry)
    }

    /// 時間と共に変化させる間隔とビュー
    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [BirthDayEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = BirthDayEntry(date: entryDate, users: [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
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

    // ← ここでサイズを取得
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        case .systemLarge:
            largeView
        default:
            mediumView
        }
    }

    // 小サイズ
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

    // 中サイズ
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

    // 大サイズ
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

    private func headerView() -> some View {
        VStack {
            HStack {
                appIcon(size: 20)
                Text("みんなの誕生日")
                    .fontS(bold: true)
            }
            Divider()
        }
    }

    private func emptyDataView() -> some View {
        VStack {
            Spacer()

            Text("誕生日情報がありません。")
                .fontSS(bold: true)

            Spacer()

            Text("アプリから登録してね♪")
                .fontSS(bold: true)

            Spacer()
        }
    }

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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemMedium) {
    BirthDayWidget()
} timeline: {
    BirthDayEntry(date: .now, users: User.demoUsers)
    BirthDayEntry(date: .now, users: User.demoUsers)
}
