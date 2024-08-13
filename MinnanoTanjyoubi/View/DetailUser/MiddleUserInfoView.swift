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
    @State private var isDisplayAgeMonth = false

    private var roundWidth: CGFloat {
        if deviceWidth < 400 {
            return 50
        } else {
            return 65
        }
    }

    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(user.currentAge)歳")
                if isDisplayAgeMonth {
                    Text("\(user.currentAgeMonth)ヶ月")
                }
            }.circleBorderView(width: roundWidth, height: roundWidth, color: Asset.Colors.themaColor2.swiftUIColor)

            Text(user.signOfZodiac)
                .circleBorderView(width: roundWidth, height: roundWidth, color: Asset.Colors.themaColor4.swiftUIColor)

            Text(user.zodiac)
                .circleBorderView(width: roundWidth, height: roundWidth, color: Asset.Colors.themaColor3.swiftUIColor)

        }.font(isSESize ? .caption : .none)
            .onAppear {
                isDisplayAgeMonth = UserDefaultsRepository.sheard.getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
            }
    }
}
