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
    @AppStorage("LimitCapacity") var limitCapacity = 10 // 初期値

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - ViewComponent

            UpSideView()

            // List ここから
            List {
                // MARK: - (1)

                Section(header: Text("通知設定"), footer: Text("・通知設定を変更以降にONにした通知を設定します。\n・通知メッセージは{userName}部分が名前に自動で置き換わります。").textSelection(.enabled)) {
                    // 通知時間
                    HStack {
                        Image(systemName: "clock").settingIcon()
                        TimePickerView()
                    }
                    // 通知日時
                    HStack {
                        Image(systemName: "calendar").settingIcon()
                        NoticeDateFlagView()
                    }

                    // 通知メッセージ
                    HStack {
                        Image(systemName: "text.bubble").settingIcon()
                        NoticeMsgView()
                    }

                }.listRowBackground(ColorAsset.foundationColorDark.thisColor)

                // MARK: - (2)

                Section(header: Text("広告"), footer: Text("・追加される容量は5個です。\n・容量の追加は1日に1回までです。")) {
                    RewardButtonView()
                    HStack {
                        Image(systemName: "bag").settingIcon()
                        Text("現在の容量:\(limitCapacity)人")
                    }
                }.listRowBackground(ColorAsset.foundationColorDark.thisColor)

                // MARK: - (3)

                Section(header: Text("Link"), footer: Text("")) {
                    // 1:レビューページ
                    Link(destination: URL(string: "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E8%AA%95%E7%94%9F%E6%97%A5/id1673431227?action=write-review")!, label: {
                        HStack {
                            Image(systemName: "hand.thumbsup").settingIcon()
                            Text("アプリをレビューする")
                        }
                    }).listRowBackground(ColorAsset.foundationColorDark.thisColor)

                    // 2:シェアボタン
                    ShareButtonView().listRowBackground(ColorAsset.foundationColorDark.thisColor)

                    // 3:利用規約とプライバシーポリシー
                    Link(destination: URL(string: "https://tech.amefure.com/app-terms-of-service")!, label: {
                        HStack {
                            Image(systemName: "note.text").settingIcon()
                            Text("利用規約とプライバシーポリシー")
                            Image(systemName: "link").font(.caption)
                        }
                    }).listRowBackground(ColorAsset.foundationColorDark.thisColor)
                }

            }.listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(ColorAsset.foundationColorLight.thisColor)
                .foregroundColor(.white)
            // List ここまで

        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .background(ColorAsset.foundationColorLight.thisColor)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
