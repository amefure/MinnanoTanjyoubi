//
//  CheckRowUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift
import SwiftUI

/// Toggleボタンのカスタマイズ構造体
struct CheckBoxToggleStyle: ToggleStyle {
    public var user: User
    @Binding var deleteIdArray: [ObjectId]

    func makeBody(configuration: Configuration) -> some View {
        Button {
            if configuration.isOn {
                deleteIdArray.remove(at: deleteIdArray.firstIndex(of: user.id)!)
            } else {
                deleteIdArray.append(user.id)
            }
            configuration.isOn.toggle()

        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            }
        }.onAppear {
            if deleteIdArray.isEmpty {
                // カウントが0 = キャンセルボタン押下後ならトグルをリセット
                configuration.isOn = false
            }
        }
    }
}

/// 削除時のリスト選択ボタン
struct CheckRowUserView: View {
    public var user: User

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
            }.toggleStyle(CheckBoxToggleStyle(user: user, deleteIdArray: $rootEnvironment.deleteIdArray))
                .tint(AppColorScheme.getThema1(rootEnvironment.scheme))
                .frame(width: itemWidth)
                .zIndex(2)
                .position(x: 15, y: 15)
                .font(.system(size: 17))

            Button {
                if isOn {
                    rootEnvironment.removeDeleteIdArray(id: user.id)
                } else {
                    rootEnvironment.appendDeleteIdArray(id: user.id)
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
