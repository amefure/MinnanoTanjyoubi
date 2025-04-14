//
//  RowUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI

/// リスト表示させる1行単位のビュー
struct RowUserView: View {
    public var user: User

    @State private var isDisplayDateLater = false
    @State private var isDisplayAgeMonth = false

    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                    .font(.system(size: DeviceSizeUtility.isSESize ? changeFontSizeByLength(user.name) : 16))

                if user.isYearsUnknown {
                    Text(DateFormatUtility().getJpStringOnlyDate(date: user.date))
                        .fontSS()
                } else {
                    Text(DateFormatUtility().getJpString(date: user.date))
                        .fontSS()
                }

                HStack(alignment: .bottom, spacing: 3) {
                    if user.isYearsUnknown {
                        Text("-")
                            .fontM()
                    } else {
                        Text("\(user.currentAge)")
                            .fontM()
                    }
                    Text("歳")
                        .fontSS()

                    if isDisplayAgeMonth && !user.isYearsUnknown {
                        Text("\(user.currentAgeMonth)")
                            .fontM()
                        Text("ヶ月")
                            .fontSS()
                    }
                }

                HStack(alignment: .bottom) {
                    if user.daysLater == 0 {
                        Text(DeviceSizeUtility.isSESize ? "HAPPY\nBIRTHDAY" : "HAPPY BIRTHDAY")
                            .foregroundStyle(AppColorScheme.getThema1(rootEnvironment.scheme))
                            .fontWeight(.bold)
                            .frame(height: 25)
                            .font(DeviceSizeUtility.isSESize ? .system(size: 10) : .system(size: 12))

                    } else {
                        if isDisplayDateLater,
                           let month = user.monthLater
                        {
                            Text("あと")
                            Text("\(month)")
                                .fontM()
                                .foregroundColor(AppColorScheme.getThema1(rootEnvironment.scheme))
                            Text("ヶ月")
                        } else {
                            Text("あと")
                            Text("\(user.daysLater)")
                                .fontM()
                                .foregroundColor(AppColorScheme.getThema1(rootEnvironment.scheme))
                            Text("日")
                        }
                    }

                }.multilineTextAlignment(.center)
                    .font(.system(size: 12))
                    .onAppear {
                        isDisplayDateLater = rootEnvironment.getDisplayDaysLater()
                        isDisplayAgeMonth = rootEnvironment.getDisplayAgeMonth()
                    }
            }.padding(5)
                .frame(height: 130)
                .frame(maxWidth: DeviceSizeUtility.deviceWidth / 3)
                .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            if user.daysLater == 0 {
                GarlandView()
                    .environmentObject(rootEnvironment)
            }
        }
    }
}

// MARK: - ガーランド三角形

struct GarlandView: View {
    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema1.swiftUIColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema2.swiftUIColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema3.swiftUIColor)
                    .frame(width: 15, height: 1)
            }.rotationEffect(Angle(degrees: 140.0))

            Spacer()

            HStack(spacing: 0) {
                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema3.swiftUIColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema2.swiftUIColor)
                    .frame(width: 15, height: 1)

                FlattenedTriangle()
                    .fill(Asset.Colors.scheme1Thema1.swiftUIColor)
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
