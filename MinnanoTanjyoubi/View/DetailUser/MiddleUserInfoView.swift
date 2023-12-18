//
//  MiddleUserInfoView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

// MARK: - 年齢/星座/干支

struct MiddleUserInfoView: View {
    // MARK: - Models

    let user: User

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isSESize = DeviceSizeManager.isSESize

    private var roundWidth: CGFloat {
        if deviceWidth < 400 {
            return 50
        } else {
            return 65
        }
    }

    var body: some View {
        HStack(spacing: 20) {
            Text("\(user.currentAge)歳")
                .circleBorderView(width: roundWidth, height: roundWidth, color: ColorAsset.themaColor2.thisColor)

            Text(user.signOfZodiac)
                .circleBorderView(width: roundWidth, height: roundWidth, color: ColorAsset.themaColor4.thisColor)

            Text(user.zodiac)
                .circleBorderView(width: roundWidth, height: roundWidth, color: ColorAsset.themaColor3.thisColor)

        }.font(isSESize ? .caption : .none)
    }
}
