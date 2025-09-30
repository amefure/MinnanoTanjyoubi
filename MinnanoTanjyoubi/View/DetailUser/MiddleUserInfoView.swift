//
//  MiddleUserInfoView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

/// 年齢/星座/干支
struct MiddleUserInfoView: View {
    let user: User

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize
    @State private var isDisplayAgeMonth = false

    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                if user.isYearsUnknown {
                    Text("- 歳")
                } else {
                    Text("\(UserCalcUtility.currentAge(from: user.date))歳")
                    if isDisplayAgeMonth {
                        Text("\(UserCalcUtility.currentAgeMonth(from: user.date))ヶ月")
                    }
                }
            }.circleBorderView(width: roundWidth, height: roundWidth, color: rootEnvironment.scheme.thema2)

            Text(UserCalcUtility.signOfZodiac(from: user.date))
                .circleBorderView(width: roundWidth, height: roundWidth, color: rootEnvironment.scheme.thema4)

            if user.isYearsUnknown {
                Text("- 年")
                    .circleBorderView(width: roundWidth, height: roundWidth, color: rootEnvironment.scheme.thema3)
            } else {
                Text(UserCalcUtility.zodiac(from: user.date))
                    .circleBorderView(width: roundWidth, height: roundWidth, color: rootEnvironment.scheme.thema3)
            }

        }.font(isSESize ? .system(size: 12) : .system(size: 17))
            .foregroundStyle(.white)
            .onAppear {
                isDisplayAgeMonth = rootEnvironment.getDisplayAgeMonth()
            }
    }
}
