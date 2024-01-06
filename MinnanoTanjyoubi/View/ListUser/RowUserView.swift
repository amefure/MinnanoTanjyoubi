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

    public var user: User

    @State private var isDisplayDateLater = false

    /// 文字数でフォントサイズを調整
    private func changeFontSizeByLength(_ name: String) -> CGFloat {
        if name.count > 8 {
            return 10
        } else {
            return 13
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                Text("\(user.name)")
                    .lineLimit(1)
                    .font(.system(size: DeviceSizeManager.isSESize ? changeFontSizeByLength(user.name) : 16))

                Text(DateFormatManager().getJpString(date: user.date))
                    .font(.caption)

                HStack(alignment: .bottom, spacing: 3) {
                    Text("\(user.currentAge)")
                    Text("歳")
                        .font(.caption)
                }

                HStack(alignment: .bottom) {
                    if user.daysLater == 0 {
                        Text(DeviceSizeManager.isSESize ? "HAPPY\nBIRTHDAY" : "HAPPY BIRTHDAY")
                            .foregroundStyle(ColorAsset.themaColor4.thisColor)
                            .fontWeight(.bold)
                            .frame(height: 25)
                            .font(DeviceSizeManager.isSESize ? .system(size: 10) : .caption)

                    } else {
                        if isDisplayDateLater,
                           let month = user.monthLater
                        {
                            Text("あと")
                            Text("\(month)")
                                .font(.title2)
                                .foregroundColor(ColorAsset.themaColor4.thisColor)
                            Text("ヶ月")
                        } else {
                            Text("あと")
                            Text("\(user.daysLater)")
                                .font(.title2)
                                .foregroundColor(ColorAsset.themaColor4.thisColor)
                            Text("日")
                        }
                    }

                }.multilineTextAlignment(.center)
                    .font(.caption)
                    .onAppear {
                        isDisplayDateLater = UserDefaultsRepository.sheard.getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
                    }
            }.padding(5)
                .frame(height: 130)
                .frame(maxWidth: DeviceSizeManager.deviceWidth / 3)
                .background(ColorAsset.foundationColorDark.thisColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            if user.daysLater == 0 {
                GarlandView()
            }
        }
    }
}

// MARK: - ガーランド三角形

struct GarlandView: View {
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                FlattenedTriangle()
                    .fill(ColorAsset.themaColor1.thisColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(ColorAsset.themaColor2.thisColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(ColorAsset.themaColor3.thisColor)
                    .frame(width: 15, height: 1)
            }.rotationEffect(Angle(degrees: 140.0))

            Spacer()

            HStack(spacing: 0) {
                FlattenedTriangle()
                    .fill(ColorAsset.themaColor3.thisColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(ColorAsset.themaColor2.thisColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(ColorAsset.themaColor1.thisColor)
                    .frame(width: 15, height: 1)
            }.rotationEffect(Angle(degrees: -140.0))

        }.offset(y: 20)
    }
}

// 三角形
public struct FlattenedTriangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let centerX = rect.midX
        let centerY = rect.midY
        let sideLength = rect.width
        let topShortening: CGFloat = 0.3 // トップの長さ調整用

        // Top
        path.move(to: CGPoint(x: centerX, y: centerY - 0.5 * sideLength + topShortening * sideLength))
        // Bottom Right
        path.addLine(to: CGPoint(x: centerX + 0.5 * sideLength, y: centerY + 0.5 * sideLength))
        // Bottom left
        path.addLine(to: CGPoint(x: centerX - 0.5 * sideLength, y: centerY + 0.5 * sideLength))
        path.closeSubpath()

        return path
    }
}
