//
//  CarouselCalendarView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct CarouselCalendarView: View {
    let viewModel: CalendarViewModel
    @Environment(\.rootEnvironment) private var rootEnvironment

    /// スワイプジェスチャー用オフセット
    @GestureState private var dragOffset: CGFloat = 0

    /// スワイプ中かどうか
    @State private var isSwipe: Bool = false
    private let deviceWidth = DeviceSizeUtility.deviceWidth

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(viewModel.state.yearAndMonths, id: \.id) { yearAndMonth in
                    VStack(spacing: 0) {
                        let dates = yearAndMonth.dates
                        // LazyVGridだとスワイプ時の描画が重くなる
                        ForEach(0 ..< dates.count / 7, id: \.self) { rowIndex in
                            HStack(spacing: 0) {
                                ForEach(0 ..< 7) { columnIndex in
                                    let dataIndex: Int = rowIndex * 7 + columnIndex
                                    if dataIndex < dates.count {
                                        let theDay = dates[dataIndex]
                                        TheDayView(viewModel: viewModel, theDay: theDay)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        // スワイプ中にバナーコンテナを移動させるためのオフセット
        // dragOffsetにはスワイプされている間だけその値が格納されスワイプが終了すると0になる
        // iOS18以降からかスワイプ終了あとに0にならなくなったのでスワイプ中のみオフセットするように変更
        .offset(x: isSwipe ? dragOffset : 0)
        // スワイプ完了後にバナーコンテナ自体を移動した後に固定するためのオフセット
        .offset(x: -(viewModel.state.displayCalendarIndex * deviceWidth))
        // スワイプ完了後の動作をなめらかにするためのアニメーション
        .animation(
            .linear(duration: 0.5),
            value: viewModel.state.displayCalendarIndex * deviceWidth
        )
        .animation(
            .linear(duration: 0.5),
            value: dragOffset
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                // スワイプの変化を観測しスワイプの変化分をHStackのoffsetに反映(スワイプでビューが動く部分を実装)
                .updating($dragOffset, body: { value, state, _ in
                    isSwipe = true
                    // スワイプ変化量をdragOffsetに反映
                    state = value.translation.width
                    // スワイプが完了するとdragOffsetの値は0になるはずだがならないときもある
                })
                .onEnded { value in
                    // value.translation.width：ドラッグを離した時の最終的な移動距離
                    // 0ならタップしただけなので処理終了
                    guard value.translation.width != 0 else { return }
                    // 1なら左スワイプ
                    // 0なら右スワイプ
                    let swipeFlag: CGFloat = value.translation.width > 0 ? 1 : 0

                    isSwipe = false

                    // 以下でdisplayCalendarIndexの値を変化させる
                    if swipeFlag == 1 {
                        viewModel.backMonthPage()
                    } else {
                        viewModel.forwardMonthPage()
                    }
                }
        )
    }
}

#Preview {
    CarouselCalendarView(viewModel: DIContainer.shared.resolve(CalendarViewModel.self))
}
