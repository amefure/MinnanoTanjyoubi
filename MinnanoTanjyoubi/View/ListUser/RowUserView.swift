//
//  RowUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI

// MARK: - リスト表示させる1行単位のビュー

struct RowUserView: View {
    // MARK: - Models

    @ObservedRealmObject var user: User

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isSESize = DeviceSizeManager.isSESize

    private var itemWidth: CGFloat {
        return CGFloat(deviceWidth / 3)
    }

    private func changeFontSizeByLemgth(_ name: String) -> CGFloat {
        if name.count > 8 {
            return 10
        } else {
            return 13
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("\(user.name)").lineLimit(1).font(.system(size: isSESize ? changeFontSizeByLemgth(user.name) : 16))
            Text(user.dateOfBirthString).font(.caption)

            HStack(alignment: .bottom, spacing: 3) {
                Text("\(user.currentAge)")
                Text("歳").font(.caption)
            }

            HStack(alignment: .bottom) {
                Text("あと")
                Text("\(user.daysLater)").font(.title2).foregroundColor(ColorAsset.themaColor4.thisColor)
                Text("日")
            }.multilineTextAlignment(.center)
                .lineLimit(1)
                .font(.caption)

        }.padding(5)
            .frame(height: 130)
            .frame(maxWidth: itemWidth)
            .background(ColorAsset.foundationColorDark.thisColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(color: .gray, radius: 3, x: 4, y: 4)
    }
}
