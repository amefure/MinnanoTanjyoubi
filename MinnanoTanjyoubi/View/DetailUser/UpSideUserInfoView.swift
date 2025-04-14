//
//  UpSideUserInfoView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

// MARK: - Relation/あと何日../名前/ふりがな/生年月日/和暦

struct UpSideUserInfoView: View {
    var user: User

    private let dfm = DateFormatUtility()

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    private var roundWidth: CGFloat {
        if deviceWidth < 400 {
            return 50
        } else {
            return 65
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(rootEnvironment.relationNameList[safe: user.relation.relationIndex] ?? "その他")
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .frame(maxWidth: roundWidth * 1.5)
                    .lineLimit(1)
                    .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                    .cornerRadius(5)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

                Spacer()

                HStack(alignment: .bottom) {
                    if user.daysLater == 0 {
                        Text("HAPPY BIRTHDAY")
                            .foregroundStyle(AppColorScheme.getThema1(rootEnvironment.scheme))
                            .fontWeight(.bold)

                    } else {
                        Text("あと")
                        Text("\(user.daysLater)")
                            .foregroundColor(AppColorScheme.getThema1(rootEnvironment.scheme))
                        Text("日")
                    }

                }.padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                    .cornerRadius(5)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))
            }

            Text(user.ruby)
                .font(isSESize ? .system(size: 12) : .system(size: 14))
            Text(user.name)
                .font(isSESize ? .system(size: 17) : .system(size: 20))
            HStack {
                if user.isYearsUnknown {
                    Text(dfm.getJpStringOnlyDate(date: user.date))
                    Text("（年数未設定）")
                } else {
                    Text(dfm.getJpString(date: user.date))
                    Text("（\(dfm.getJpEraString(date: user.date))）")
                }
            }.padding(.top, 8)
                .fontM()
        }
    }
}
