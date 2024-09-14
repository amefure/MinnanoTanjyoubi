//
//  SettingView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/01.
//

import SwiftUI
import UIKit

// MARK: - 設定ビュー

struct SettingView: View {
    // MARK: - ViewModel

    @StateObject private var viewModel = SettingViewModel()

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    // MARK: - View

    @State private var isLock: Bool = false
    @State private var isDaysLaterFlag: Bool = false
    @State private var isAgeMonthFlag: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - ViewComponent

            UpSideView()

            // List ここから
            List {
                // MARK: - (1)

                Section(header: Text("通知設定"),
                        footer: Text("・通知設定を変更以降にONにした通知を設定します。\n・通知メッセージは" + NotifyConfig.VARIABLE_USER_NAME + "部分が名前に自動で置き換わります。")
                            .textSelection(.enabled))
                {
                    // 通知時間
                    HStack {
                        Image(systemName: "clock").settingIcon()
                        TimePickerView(viewModel: viewModel)
                    }
                    // 通知日時
                    HStack {
                        Image(systemName: "calendar").settingIcon()
                        NoticeDateFlagView(viewModel: viewModel)
                    }

                    // 通知メッセージ
                    HStack {
                        Image(systemName: "text.bubble").settingIcon()
                        NoticeMsgView(viewModel: viewModel)
                    }

                }.listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)

                // MARK: - (2)

                Section(header: Text("アプリ設定"),
                        footer: Text("・アプリにパスワードを設定してロックをかけることができます。"))
                {
                    // 誕生日までの単位
                    HStack {
                        Image(systemName: "switch.2").settingIcon()
                        Text("誕生日までの単位を切り替える")
                        Spacer()
                        Toggle(isOn: $isDaysLaterFlag) {
                            Text(isDaysLaterFlag ? "月" : "日")
                        }.onChange(of: isDaysLaterFlag, perform: { newValue in
                            viewModel.registerDisplayDaysLater(flag: newValue)
                        }).toggleStyle(.button)
                            .opacity(0.9)
                            .background(isDaysLaterFlag ? Asset.Colors.themaColor3.swiftUIColor : Asset.Colors.themaColor2.swiftUIColor)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }

                    // 誕生日までの単位
                    HStack {
                        Image(systemName: "switch.2").settingIcon()
                        Toggle(isOn: $isAgeMonthFlag) {
                            Text("年齢の⚪︎ヶ月を表示する")
                        }.onChange(of: isAgeMonthFlag, perform: { newValue in
                            viewModel.registerDisplayAgeMonth(flag: newValue)
                        }).tint(Asset.Colors.themaColor1.swiftUIColor)
                    }

                    // 登録初期年数
                    HStack {
                        Image(systemName: "clock").settingIcon()
                        YearPickerView(viewModel: viewModel)
                    }

                    // 関係をカスタマイズ
                    NavigationLink {
                        UpdateRelationNameView()
                    } label: {
                        HStack {
                            Image(systemName: "pencil.line").settingIcon()
                            Text("関係をカスタマイズする")
                        }
                    }

                    HStack {
                        Image(systemName: "lock.iphone")
                            .settingIcon()
                        Toggle(isOn: $isLock) {
                            Text("アプリをロックする")
                        }.onChange(of: isLock, perform: { newValue in
                            if newValue {
                                viewModel.showPassInput()
                            } else {
                                viewModel.deletePassword()
                            }
                        }).tint(Asset.Colors.themaColor1.swiftUIColor)
                    }.sheet(isPresented: $viewModel.isShowPassInput, content: {
                        AppLockInputView(isLock: $isLock)
                    })
                }.listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)

                // MARK: - (3)

                Section(header: Text("広告"),
                        footer: Text("・追加される容量は\(AdsConfig.ADD_CAPACITY)個です。\n・容量の追加は1日に1回までです。"))
                {
                    RewardButtonView(viewModel: viewModel)
                    HStack {
                        Image(systemName: "bag").settingIcon()
                        Text("現在の容量:\(viewModel.getCapacity())人")
                    }
                }.listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)

                // MARK: - (4)

                Section(header: Text("Link"), footer: Text("・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。")) {
                    if let url = URL(string: StaticUrls.APP_REVIEW_URL) {
                        // 1:レビューページ
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "hand.thumbsup").settingIcon()
                                Text("アプリをレビューする")
                            }
                        }).listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)
                    }

                    // 2:シェアボタン
                    Button(action: {
                        viewModel.shareApp(
                            shareText: "友達の誕生日をメモできるアプリ「みんなの誕生日」を使ってみてね♪",
                            shareLink: StaticUrls.APP_URL
                        )
                    }) {
                        HStack {
                            Image(systemName: "star.bubble")
                                .settingIcon()
                            Text("「みんなの誕生日」をオススメする")
                        }
                    }.listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)

                    if let url = URL(string: StaticUrls.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "paperplane").settingIcon()
                                Text("アプリの不具合はこちら")
                                Image(systemName: "link")
                            }
                        }).listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)
                    }

                    if let url = URL(string: StaticUrls.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "note.text").settingIcon()
                                Text("利用規約とプライバシーポリシー")
                                Image(systemName: "link")
                            }
                        }).listRowBackground(Asset.Colors.foundationColorDark.swiftUIColor)
                    }
                }

            }.listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(Asset.Colors.foundationColorLight.swiftUIColor)
                .foregroundColor(.white)
            // List ここまで

            Spacer()

            AdMobBannerView().frame(height: 50)
        }.font(.system(size: 17))
            .onAppear {
                viewModel.onAppear()
                isLock = viewModel.isLock
                isDaysLaterFlag = viewModel.getDisplayDaysLater()
                isAgeMonthFlag = viewModel.getDisplayAgeMonth()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .background(Asset.Colors.foundationColorLight.swiftUIColor)
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
    }
}
