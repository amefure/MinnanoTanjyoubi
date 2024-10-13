//
//  SettingView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/01.
//

import SwiftUI
import UIKit

/// 設定画面
struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()

    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isLock: Bool = false
    @State private var isDaysLaterFlag: Bool = false
    @State private var isAgeMonthFlag: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            UpSideView()
                .environmentObject(rootEnvironment)

            // List ここから
            List {
                Section(header: Text("通知設定"),
                        footer:
                        Text("・通知設定を変更した場合はこれより後に通知登録した通知に反映されます。\n既にONになっている場合はON→OFF→ONと操作してください。")
                            .font(.system(size: 14))
                            .fontWeight(.bold))
                {
                    // 通知時間
                    HStack {
                        Image(systemName: "clock")
                            .settingIcon(rootEnvironment.scheme)

                        Text("通知時間")
                            .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                            .font(.system(size: 17))

                        Spacer()

                        TimePickerView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    }
                    // 通知日時
                    HStack {
                        Image(systemName: "calendar")
                            .settingIcon(rootEnvironment.scheme)
                        NoticeDateFlagView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    }

                    // 関係をカスタマイズ
                    NavigationLink {
                        EditNotifyMessageView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "text.bubble")
                                .settingIcon(rootEnvironment.scheme)
                            Text("通知メッセージを変更する")
                        }
                    }

                }.listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                Section(header: Text("アプリ設定"),
                        footer: Text("・アプリにパスワードを設定してロックをかけることができます。").font(.system(size: 14)).fontWeight(.bold))
                {
                    // 誕生日までの単位
                    HStack {
                        Image(systemName: "switch.2")
                            .settingIcon(rootEnvironment.scheme)
                        Text("誕生日までの単位を切り替える")
                        Spacer()
                        Toggle(isOn: $isDaysLaterFlag) {
                            Text(isDaysLaterFlag ? "月" : "日")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }.onChange(of: isDaysLaterFlag, perform: { newValue in
                            viewModel.registerDisplayDaysLater(flag: newValue)
                        }).toggleStyle(.button)
                            .opacity(0.9)
                            .background(isDaysLaterFlag ? AppColorScheme.getThema3(rootEnvironment.scheme) : AppColorScheme.getThema2(rootEnvironment.scheme))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }

                    // 誕生日までの単位
                    HStack {
                        Image(systemName: "switch.2")
                            .settingIcon(rootEnvironment.scheme)
                        Toggle(isOn: $isAgeMonthFlag) {
                            Text("年齢の⚪︎ヶ月を表示する")
                        }.onChange(of: isAgeMonthFlag, perform: { newValue in
                            viewModel.registerDisplayAgeMonth(flag: newValue)
                        }).tint(AppColorScheme.getThema1(rootEnvironment.scheme))
                    }

                    // 登録初期年数
                    HStack {
                        Image(systemName: "clock")
                            .settingIcon(rootEnvironment.scheme)
                        YearPickerView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    }

                    // 関係をカスタマイズ
                    NavigationLink {
                        UpdateRelationNameView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "pencil.line")
                                .settingIcon(rootEnvironment.scheme)
                            Text("関係をカスタマイズする")
                        }
                    }

                    // 関係をカスタマイズ
                    NavigationLink {
                        SelectColorScheme()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "paintpalette")
                                .settingIcon(rootEnvironment.scheme)
                            Text("テーマカラーを変更する")
                        }
                    }

                    HStack {
                        Image(systemName: "lock.iphone")
                            .settingIcon(rootEnvironment.scheme)
                        Toggle(isOn: $isLock) {
                            Text("アプリをロックする")
                        }.onChange(of: isLock, perform: { newValue in
                            if newValue {
                                viewModel.showPassInput()
                            } else {
                                viewModel.deletePassword()
                            }
                        }).tint(AppColorScheme.getThema1(rootEnvironment.scheme))
                    }.sheet(isPresented: $viewModel.isShowPassInput, content: {
                        AppLockInputView(isLock: $isLock)
                            .environmentObject(rootEnvironment)
                    })
                }.listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                Section(header: Text("広告"),
                        footer: Text("・追加される容量は\(AdsConfig.ADD_CAPACITY)人です。\n・容量の追加は1日に1回までです。").font(.system(size: 14)).fontWeight(.bold))
                {
                    RewardButtonView(viewModel: viewModel)
                        .environmentObject(rootEnvironment)
                    HStack {
                        Image(systemName: "bag")
                            .settingIcon(rootEnvironment.scheme)
                        Text("現在 / 容量 ： ")
                        Text("\(repository.users.count)")
                            .fontWeight(.bold)
                            .foregroundStyle(repository.users.count == viewModel.getCapacity() ? AppColorScheme.getThema1(rootEnvironment.scheme) : AppColorScheme.getText(rootEnvironment.scheme))
                        Text("人 / ")
                        Text("\(viewModel.getCapacity())")
                            .fontWeight(.bold)
                            .foregroundStyle(AppColorScheme.getThema1(rootEnvironment.scheme))
                        Text("人")
                    }
                }.listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                Section(header: Text("Link"), footer: Text("・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。").font(.system(size: 14)).fontWeight(.bold)) {
                    // よくある質問
                    NavigationLink {
                        FaqListView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.app")
                                .settingIcon(rootEnvironment.scheme)
                            Text("よくある質問")
                        }
                    }

                    if let url = URL(string: StaticUrls.APP_REVIEW_URL) {
                        // 1:レビューページ
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "hand.thumbsup")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("アプリをレビューする")
                            }
                        })
                    }

                    // 2:シェアボタン
                    Button {
                        viewModel.shareApp(
                            shareText: "友達の誕生日をメモできるアプリ「みんなの誕生日」を使ってみてね♪",
                            shareLink: StaticUrls.APP_URL
                        )
                    } label: {
                        HStack {
                            Image(systemName: "star.bubble")
                                .settingIcon(rootEnvironment.scheme)
                            Text("「みんなの誕生日」をオススメする")
                        }
                    }

                    if let url = URL(string: StaticUrls.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("アプリの不具合はこちら")
                                Image(systemName: "link")
                            }
                        }).listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                    }

                    if let url = URL(string: StaticUrls.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "note.text")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("利用規約とプライバシーポリシー")
                                Image(systemName: "link")
                            }
                        })
                    }
                }.listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

            }.listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
                .foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
            // List ここまで

            Spacer()

            AdMobBannerView()
                .frame(height: 50)

        }.font(.system(size: 17))
            .onAppear {
                viewModel.onAppear()
                isLock = viewModel.isLock
                isDaysLaterFlag = viewModel.getDisplayDaysLater()
                isAgeMonthFlag = viewModel.getDisplayAgeMonth()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .dialog(
                isPresented: $viewModel.isAlertReward,
                title: "お知らせ",
                message: "広告を視聴できるのは1日に1回までです。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    viewModel.isAlertReward = false
                },
                negativeAction: {}
            )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(RootEnvironment())
    }
}
