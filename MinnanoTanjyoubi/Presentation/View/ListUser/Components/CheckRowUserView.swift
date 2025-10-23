//
//  CheckRowUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift
import SwiftUI

/// Toggleボタンのカスタマイズ構造体
private struct CheckBoxToggleStyle: ToggleStyle {
    var user: User
    @Binding var deleteArray: [User]

    func makeBody(configuration: Configuration) -> some View {
        Button {
            if configuration.isOn {
                guard let index = deleteArray.firstIndex(of: user) else { return }
                deleteArray.remove(at: index)
            } else {
                deleteArray.append(user)
            }
            configuration.isOn.toggle()

        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            }
        }.onAppear {
            if deleteArray.isEmpty {
                // カウントが0 = キャンセルボタン押下後ならトグルをリセット
                configuration.isOn = false
            }
        }
    }
}

/// 削除時のリスト選択ボタン
struct CheckRowUserView: View {
    var user: User

    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isOn = false

    private var itemWidth: CGFloat {
        return CGFloat(DeviceSizeUtility.deviceWidth / 3)
    }

    var body: some View {
        ZStack {
            // チェックボタン
            Toggle(isOn: $isOn) {
                EmptyView()
            }.toggleStyle(CheckBoxToggleStyle(user: user, deleteArray: $rootEnvironment.deleteArray))
                .tint(rootEnvironment.scheme.thema1)
                .frame(width: itemWidth)
                .zIndex(2)
                .position(x: 15, y: 15)
                .font(.system(size: 17))

            Button {
                if isOn {
                    rootEnvironment.removeDeleteArray(user)
                } else {
                    rootEnvironment.appendDeleteArray(user)
                }
                isOn.toggle()
            } label: {
                RowUserView(user: user)
                    .opacity(isOn ? 1 : 0.7)
                    .zIndex(1)
                    .environmentObject(rootEnvironment)
            }
        }
    }
}
