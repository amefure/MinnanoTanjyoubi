//
//  CheckRowUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift
import SwiftUI

// MARK: - Toggleボタンのカスタマイズ構造体

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
            if deleteIdArray.count == 0 {
                // カウントが0 = キャンセルボタン押下後ならトグルをリセット
                configuration.isOn = false
            }
        }
    }
}

// MARK: - 削除時のリスト選択ボタン

struct CheckRowUserView: View {
    // MARK: - Models

    public var user: User

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    // MARK: - View

    @State var isOn: Bool = false

    // MARK: - Setting

    private var itemWidth: CGFloat {
        return CGFloat(DeviceSizeManager.deviceWidth / 3)
    }

    var body: some View {
        ZStack {
            // チェックボタン
            Toggle(isOn: $isOn) {
                EmptyView()
            }.toggleStyle(CheckBoxToggleStyle(user: user, deleteIdArray: $rootEnvironment.deleteIdArray))
                .tint(Asset.Colors.themaColor1.swiftUIColor)
                .frame(width: itemWidth)
                .zIndex(2)
                .position(x: 15, y: 15)

            //
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
            }
        }
    }
}
