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

    // dismissで実装するとCPUがオーバーフローする
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            UpSideView()
                .environmentObject(rootEnvironment)

            // List ここから
            List {
                if rootEnvironment.unlockStorage {
                    HStack {
                        VStack {
                            Text("アプリ容量")
                                .fontM(bold: true)
                                .frame(width: DeviceSizeUtility.deviceWidth - 80, alignment: .leading)

                            HStack {
                                Image(systemName: "lock.open")
                                    .fontL()
                                    .foregroundStyle(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Asset.Colors.exThemaYellow.swiftUIColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 40))

                                Text("UNLOCK STORAGE")
                                    .opacity(0.1)

                                Spacer()

                                Rectangle()
                                    .fill(Asset.Colors.exText.swiftUIColor)
                                    .frame(width: 1)
                                    .opacity(0.1)

                                Spacer()

                                VStack {
                                    Text("登録数")
                                        .fontS()
                                        .opacity(0.5)
                                        .padding(.bottom, 8)
                                    HStack(alignment: .bottom) {
                                        Text("\(repository.users.count)")
                                            .foregroundStyle(Asset.Colors.exThemaRed.swiftUIColor)
                                            .fontCustom(size: 30, bold: true)
                                        Text("人")
                                            .fontM()
                                            .offset(y: -3)
                                    }.padding(.leading, 8)
                                }

                                Spacer()
                            }.fontCustom(size: 35, bold: true)

                            Spacer()
                        }

                    }.foregroundStyle(Asset.Colors.exText.swiftUIColor)

                } else {
                    CapacityParametersView(
                        now: Double(repository.users.count),
                        max: Double(viewModel.getCapacity())
                    ).foregroundStyle(Asset.Colors.exText.swiftUIColor)
                        .environmentObject(rootEnvironment)
                }

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
                    }.listRowHeight()
                    // 通知日時
                    HStack {
                        Image(systemName: "calendar")
                            .settingIcon(rootEnvironment.scheme)
                        NoticeDateFlagView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    }.listRowHeight()

                    // 通知メッセージを変更する
                    NavigationLink {
                        EditNotifyMessageView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "text.bubble")
                                .settingIcon(rootEnvironment.scheme)
                            Text("通知メッセージを変更する")
                        }
                    }.listRowHeight()

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
                    }.listRowHeight()

                    // 誕生日までの単位
                    HStack {
                        Image(systemName: "switch.2")
                            .settingIcon(rootEnvironment.scheme)
                        Toggle(isOn: $isAgeMonthFlag) {
                            Text("年齢の⚪︎ヶ月を表示する")
                        }.onChange(of: isAgeMonthFlag, perform: { newValue in
                            viewModel.registerDisplayAgeMonth(flag: newValue)
                        }).tint(AppColorScheme.getThema1(rootEnvironment.scheme))
                    }.listRowHeight()

                    // 登録初期年数
                    HStack {
                        Image(systemName: "clock")
                            .settingIcon(rootEnvironment.scheme)
                        YearPickerView(viewModel: viewModel)
                            .environmentObject(rootEnvironment)
                    }.listRowHeight()

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
                    }.listRowHeight()

                    // テーマカラーを変更する
                    NavigationLink {
                        SelectColorScheme()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "paintpalette")
                                .settingIcon(rootEnvironment.scheme)
                            Text("テーマカラーを変更する")
                        }
                    }.listRowHeight()

                    // 並び順を変更する
                    NavigationLink {
                        SelectSortView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                                .settingIcon(rootEnvironment.scheme)
                            Text("並び順を変更する")
                        }
                    }.listRowHeight()

                    // 誕生日情報を共有する
                    NavigationLink {
                        ShareUserLinkView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "person.line.dotted.person")
                                .settingIcon(rootEnvironment.scheme)
                            Text("誕生日情報を転送(共有)する")
                        }
                    }.listRowHeight()

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
                    }.listRowHeight()
                        .sheet(isPresented: $viewModel.isShowPassInput, content: {
                            AppLockInputView(isLock: $isLock)
                                .environmentObject(rootEnvironment)
                        })
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
                    }.listRowHeight()

                    // アプリの使い方
                    Button {
                        viewModel.setTutorialReShowFlag()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.and.hand.point.up.left")
                                .settingIcon(rootEnvironment.scheme)
                            Text("アプリの使い方(チュートリアル)")
                        }
                    }.listRowHeight()

                    // アプリ内課金
                    NavigationLink {
                        InAppPurchaseView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "app.gift.fill")
                                .settingIcon(rootEnvironment.scheme)
                            Text("広告削除 & 容量解放")
                        }
                    }.listRowHeight()

                    if let url = URL(string: StaticUrls.APP_REVIEW_URL) {
                        // 1:レビューページ
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "hand.thumbsup")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("アプリをレビューする")
                            }
                        }).listRowHeight()
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
                    }.listRowHeight()

                    if let url = URL(string: StaticUrls.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        NavigationLink {
                            ControlWebView(url: url)
                                .environmentObject(rootEnvironment)
                        } label: {
                            HStack {
                                Image(systemName: "paperplane")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("アプリの不具合はこちら")
                            }
                        }.listRowHeight()
                    }

                    if let url = URL(string: StaticUrls.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        NavigationLink {
                            ControlWebView(url: url)
                                .environmentObject(rootEnvironment)
                        } label: {
                            HStack {
                                Image(systemName: "note.text")
                                    .settingIcon(rootEnvironment.scheme)
                                Text("利用規約とプライバシーポリシー")
                            }
                        }.listRowHeight()
                    }
                }.listRowBackground(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        Asset.Images.appiconRemove.swiftUIImage
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(5)
                            .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .padding(.bottom, 8)

                        Text("『大切な人の大切な日を忘れずにお祝いするためのアプリ』")
                        Text("みんなの誕生日 Ver \(viewModel.getVersion())")
                        Text("Created by Shibuya")
                    }.fontSS()
                    Spacer()
                }.listRowBackground(Color.clear)

            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
                .foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
            // List ここまで

            Spacer()

            if !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

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
    }
}

private extension View {
    func listRowHeight(height: CGFloat = 37) -> some View {
        frame(height: height)
    }
}

struct CapacityParametersView: View {
    public let now: Double
    public let max: Double
    public let color: Color = Asset.Colors.exThemaYellow.swiftUIColor
    public let fullColor: Color = Asset.Colors.exThemaRed.swiftUIColor
    public let width: CGFloat = DeviceSizeUtility.deviceWidth - 80
    public let height: CGFloat = 40
    public let radius: CGFloat = 8

    @State private var target: Double = 0
    @State private var showCapacity: CGFloat = 0
    @State private var presentInAppPurchaseView: Bool = false

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(spacing: 8) {
                    Text("アプリ容量")
                        .fontM(bold: true)
                        .frame(width: width - 40, alignment: .leading)
                    Text("・追加される容量は\(AdsConfig.ADD_CAPACITY)人です。\n・容量の追加は1日に1回までです。")
                        .fontS()
                        .frame(width: width - 40, alignment: .leading)
                }

                Spacer()

                Button {
                    presentInAppPurchaseView = true
                } label: {
                    Image(systemName: "lock.open")
                        .fontL()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Asset.Colors.exThemaYellow.swiftUIColor)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .shadow(color: .gray, radius: 1, x: 2, y: 2)
                }.buttonStyle(.plain)
                    .navigationDestination(isPresented: $presentInAppPurchaseView) {
                        InAppPurchaseView()
                            .environmentObject(rootEnvironment)
                    }
            }

            HStack {
                Text(now >= max ? "FULL" : "\(Int(now))人")
                    .fontM(bold: true)
                    .frame(
                        width: Swift.max(30, width * (min(now, max) / max) + 25),
                        alignment: target == 0 ? .leading : .trailing
                    )
                    .foregroundStyle(target >= max ? fullColor : Asset.Colors.exText.swiftUIColor)
                    .opacity(showCapacity)
                Spacer()
            }.frame(width: width + 20, height: 20)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: radius)
                    .stroke()

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.25)

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.5)

                Rectangle()
                    .fill(.gray)
                    .opacity(0.5)
                    .frame(width: 1, height: height - 10)
                    .offset(x: width * 0.75)

                Rectangle()
                    .fill(target >= max ? fullColor : color)
                    .frame(width: width * (min(target, max) / max), height: height)

            }.frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: radius))

            HStack {
                Text("0人")
                    .fontS()

                Spacer()

                Text("\(Int(max))人")
                    .fontS()
            }.frame(width: width + 20, alignment: .leading)

            RewardButtonView()
                .environmentObject(rootEnvironment)
        }.onAppear {
            withAnimation(Animation.linear(duration: 2)) {
                target = now
                showCapacity = 1
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(RootEnvironment())
    }
}
