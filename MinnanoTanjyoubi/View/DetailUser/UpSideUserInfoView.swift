//
//  UpSideUserInfoView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

// MARK: - Relation/あと何日../名前/ふりがな/生年月日/和暦

struct UpSideUserInfoView: View {
    // MARK: - Models

    var user: User

    // MARK: - Controller

    private let dfm = DateFormatUtility()

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

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(rootEnvironment.relationNameList[safe: user.relation.relationIndex] ?? "その他")
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .frame(maxWidth: roundWidth * 1.5)
                    .lineLimit(1)
                    .background(ColorAsset.foundationColorDark.thisColor)
                    .cornerRadius(5)
                    .font(isSESize ? .caption : .none)

                Spacer()

                HStack(alignment: .bottom) {
                    if user.daysLater == 0 {
                        Text("HAPPY BIRTHDAY")
                            .foregroundStyle(ColorAsset.themaColor4.thisColor)
                            .fontWeight(.bold)

                    } else {
                        Text("あと")
                        Text("\(user.daysLater)")
                            .foregroundColor(ColorAsset.themaColor1.thisColor)
                        Text("日")
                    }

                }.padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .background(ColorAsset.foundationColorDark.thisColor)
                    .cornerRadius(5)
                    .font(isSESize ? .caption : .none)
            }

            Text(user.ruby)
                .font(isSESize ? .caption : .none)
            Text(user.name)
                .font(isSESize ? .title : .largeTitle)
            HStack {
                Text(dfm.getJpString(date: user.date))
                Text("（\(dfm.getJpEraString(date: user.date))）")
            }
        }
    }
}
