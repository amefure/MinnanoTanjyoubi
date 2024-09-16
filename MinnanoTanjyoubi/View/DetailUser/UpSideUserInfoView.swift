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

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

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
                    .background(Asset.Colors.foundationColorDark.swiftUIColor)
                    .cornerRadius(5)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

                Spacer()

                HStack(alignment: .bottom) {
                    if user.daysLater == 0 {
                        Text("HAPPY BIRTHDAY")
                            .foregroundStyle(Asset.Colors.themaColor4.swiftUIColor)
                            .fontWeight(.bold)

                    } else {
                        Text("あと")
                        Text("\(user.daysLater)")
                            .foregroundColor(Asset.Colors.themaColor1.swiftUIColor)
                        Text("日")
                    }

                }.padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .background(Asset.Colors.foundationColorDark.swiftUIColor)
                    .cornerRadius(5)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))
            }

            Text(user.ruby)
                .font(isSESize ? .system(size: 12) : .system(size: 17))
            Text(user.name)
                .font(isSESize ? .system(size: 17) : .system(size: 20))
            HStack {
                Text(dfm.getJpString(date: user.date))
                    .font(.system(size: 17))
                Text("（\(dfm.getJpEraString(date: user.date))）")
                    .font(.system(size: 17))
            }
        }
    }
}
