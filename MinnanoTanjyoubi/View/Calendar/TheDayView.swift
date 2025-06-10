//
//  TheDayView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct TheDayView: View {
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    public let theDay: SCDate

    /// 上限に達した場合のアラート
    @State private var isLimitAlert: Bool = false
    /// 新規登録モーダル表示
    @State private var isShowEntryModal: Bool = false
    /// 複数誕生日リストモーダル表示
    @State private var isShowMulchModal: Bool = false
    /// 詳細画面表示
    @State private var isShowDetailView: Bool = false
    /// 複数存在時に詳細画面に遷移するUser情報を保持する
    @State private var user: User? = nil

    var body: some View {
        VStack {
            if theDay.day == -1 {
                AppColorScheme.getFoundationPrimary(rootEnvironment.scheme)
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(theDay.day)")
                        .frame(width: 18, height: 18)
                        .background(theDay.isToday ? Asset.Colors.exThemaRed.swiftUIColor : Color.clear)
                        .fontSS(bold: true)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor(defaultColor: AppColorScheme.getText(rootEnvironment.scheme)))

                    // 最大3人まで表示
                    ForEach(theDay.users.prefix(3)) { user in
                        Text(user.name)
                            .lineLimit(1)
                            .fontSSS(bold: true)
                            .foregroundStyle(.white)
                            .frame(height: 15)
                            .frame(maxWidth: .infinity)
                            .background(theDay.isToday ? Asset.Colors.exThemaRed.swiftUIColor : Asset.Colors.exThemaYellow.swiftUIColor)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }

                    // スペーサー用(スワイプタップ判定領域確保のため)
                    AppColorScheme.getFoundationSub(rootEnvironment.scheme)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 3)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in

                            if theDay.users.count == 0 {
                                // 0なら新規登録
                                // 容量がオーバーしていないか または 容量解放されている
                                if !repository.isOverCapacity(1) || rootEnvironment.unlockStorage {
                                    // 登録モーダル表示
                                    isShowEntryModal.toggle()
                                } else {
                                    // 容量オーバーアラート表示
                                    isLimitAlert = true
                                }
                            } else if theDay.users.count == 1 {
                                // 1なら詳細画面へ遷移
                                isShowDetailView = true
                            } else if theDay.users.count >= 2 {
                                // 2以上ならリスト表示
                                isShowMulchModal = true
                            }
                        }
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DeviceSizeUtility.isSESize ? 68 : 80)
        .overlay {
            Rectangle()
                .stroke(AppColorScheme.getText(rootEnvironment.scheme), lineWidth: 2)
        }.if(theDay.users.count == 0) { view in
            view
                .sheet(isPresented: $isShowEntryModal) {
                    EntryUserView(
                        user: nil,
                        isCalendarMonth: theDay.month,
                        isCalendarDay: theDay.day,
                        isModal: $isShowEntryModal
                    )
                    .environmentObject(rootEnvironment)
                }.alert(
                    isPresented: $isLimitAlert,
                    title: "Error...",
                    message: "保存容量が上限に達しました。\n設定から広告を視聴すると\n保存容量を増やすことができます。",
                    positiveButtonTitle: "OK",
                    negativeButtonTitle: "",
                    positiveAction: {
                        isLimitAlert = false
                    },
                    negativeAction: {}
                )
        }.if(theDay.users.count == 1) { view in
            view
                .navigationDestination(isPresented: $isShowDetailView) {
                    DetailUserView(user: theDay.users.first!)
                        .environmentObject(rootEnvironment)
                }
        }.if(theDay.users.count >= 2) { view in
            view
                .sheet(isPresented: $isShowMulchModal) {
                    mulchUserSelectListView()
                }.navigationDestination(isPresented: $isShowDetailView) {
                    if let user = user {
                        DetailUserView(user: user)
                            .environmentObject(rootEnvironment)
                    }
                }
        }
    }

    /// 複数のユーザーが紐づいている場合専用のリスト表示ビュー
    private func mulchUserSelectListView() -> some View {
        VStack(spacing: 0) {
            Text(theDay.getDate())
                .fontM(bold: true)
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))

            ScrollView(.horizontal) {
                HStack {
                    ForEach(theDay.users) { user in
                        Button {
                            isShowMulchModal = false
                            self.user = user
                            isShowDetailView = true
                        } label: {
                            RowUserView(user: user)
                                .frame(width: CGFloat(DeviceSizeUtility.deviceWidth / 3) - 10)
                                .environmentObject(rootEnvironment)
                        }.buttonStyle(.plain)
                    }
                }
            }.padding(.vertical)
        }.presentationDetents([.height(200)])
            .padding()
            .ignoresSafeArea(.all)
            .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
    }
}

#Preview {
    TheDayView(theDay: SCDate.demo)
}
