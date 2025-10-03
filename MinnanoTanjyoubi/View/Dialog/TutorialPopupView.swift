//
//  TutorialPopupView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/19.
//

import SwiftUI

struct TutorialPopupView: View {
    @Binding var isPresented: Bool

    let title: String
    let message: String
    let buttonTitle: String
    let buttonAction: () -> Void
    let popupWidth: CGFloat
    let headerHeight: CGFloat
    let footerHeight: CGFloat
    let position: PopUpPosition

    var body: some View {
        if isPresented {
            ZStack {
                // 画面全体を覆う黒い背景
                Color.black
                    .opacity(0.3)

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: headerHeight)

                    if position == .bottomLeft || position == .bottomMiddle || position == .bottomRight {
                        Spacer()
                    }

                    // MARK: ポップアップ上部矢印

                    HStack {
                        switch position {
                        case .topLeft:
                            Triangle()
                                .fill(.white)
                                .frame(width: 70, height: 100)
                                .rotationEffect(Angle(degrees: 135))
                            Spacer()
                        case .topRight:
                            Spacer()
                            Triangle()
                                .fill(.white)
                                .frame(width: 70, height: 100)
                                .rotationEffect(Angle(degrees: -135))
                        default:
                            Spacer()
                        }
                    }.padding(.horizontal)
                        .frame(width: popupWidth - 90)
                        .offset(y: 40) // ポップアップにめり込ませる

                    // MARK: ポップアップコンテンツ

                    VStack {
                        Text(title)
                            .fontL(bold: true)
                            .frame(width: popupWidth - 130, alignment: .leading)
                            .foregroundStyle(Asset.Colors.exText.swiftUIColor)

                        Spacer()

                        Text(message)
                            .fontM()
                            .frame(width: popupWidth - 130, alignment: .leading)
                            .foregroundStyle(Asset.Colors.exText.swiftUIColor)

                        Spacer()

                        Button {
                            isPresented = false
                            buttonAction()
                        } label: {
                            Text(buttonTitle)
                                .fontM(bold: true)
                                .foregroundStyle(.white)
                                .frame(width: popupWidth - 130, height: 50)
                                .background(Asset.Colors.exThemaRed.swiftUIColor)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }.padding(20)
                        .frame(width: popupWidth - 90, height: 300)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    // MARK: ポップアップ下部矢印

                    HStack {
                        switch position {
                        case .bottomLeft:
                            Triangle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                            Spacer()
                        case .bottomMiddle:
                            Spacer()

                            Triangle()
                                .fill(.white)
                                .frame(width: 50, height: 50)

                            Spacer()
                        case .bottomRight:
                            Spacer()
                            Triangle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        default:
                            Spacer()
                        }
                    }.padding(.horizontal)
                        .frame(width: popupWidth - 110)

                    Spacer()
                        .frame(height: footerHeight)

                    if position == .topLeft || position == .topRight {
                        Spacer()
                    }

                }.padding(.vertical)

                // 画面一杯にViewを広げる
            }.font(.system(size: 17))
                .ignoresSafeArea()
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // 三角形の頂点を設定
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // 上の頂点
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 右下の頂点
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // 左下の頂点
        path.closeSubpath() // パスを閉じる
        return path
    }
}

extension View {
    func tutorialPopupView(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        buttonTitle: String = "",
        buttonAction: @escaping () -> Void = {},
        popupWidth: CGFloat = 300,
        headerHeight: CGFloat = 100,
        footerHeight: CGFloat = 100,
        position: PopUpPosition = .bottomRight
    ) -> some View {
        overlay(
            TutorialPopupView(
                isPresented: isPresented,
                title: title,
                message: message,
                buttonTitle: buttonTitle,
                buttonAction: buttonAction,
                popupWidth: popupWidth,
                headerHeight: headerHeight,
                footerHeight: footerHeight,
                position: position
            )
        )
    }
}

#Preview {
    TutorialPopupView(
        isPresented: Binding.constant(true),
        title: "誕生日情報を登録をしよう！",
        message: "このボタンをタップすることで友達や家族の誕生日情報を入力して登録することができます。登録した誕生日情報は一覧として表示されるよ",
        buttonTitle: "OK",
        buttonAction: {},
        popupWidth: 300,
        headerHeight: 100,
        footerHeight: 100,
        position: .topRight
    )
}
