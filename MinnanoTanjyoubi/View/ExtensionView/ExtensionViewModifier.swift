//
//  ExtensionViewModifier.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/22.
//

import SwiftUI
import UIKit

//
struct OverBorder: ViewModifier {
    let radius: CGFloat
    let color: Color
    let opacity: CGFloat
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color.opacity(opacity), lineWidth: lineWidth)
            )
    }
}

// SettingView
struct SettingIcon: ViewModifier {
    let scheme: AppColorScheme
    func body(content: Content) -> some View {
        content
            .frame(width: 30)
            .foregroundColor(AppColorScheme.getThema1(scheme))
    }
}

// ListUserView > ControlPanelView && DetailUserView
struct CircleBorderView: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding(5)
            .multilineTextAlignment(.center)
            .frame(width: width, height: height, alignment: .center)
            .background(color)
            .cornerRadius(50)
            .overBorder(radius: 50, color: color, opacity: 0.4, lineWidth: 7)
    }
}

extension View {
    func overBorder(radius: CGFloat, color: Color, opacity: CGFloat, lineWidth: CGFloat) -> some View {
        modifier(OverBorder(radius: radius, color: color, opacity: opacity, lineWidth: lineWidth))
    }

    // SettingView
    func settingIcon(_ scheme: AppColorScheme) -> some View {
        modifier(SettingIcon(scheme: scheme))
    }

    // ListUserView > ControlPanelView && DetailUserView
    func circleBorderView(width: CGFloat, height: CGFloat, color: Color) -> some View {
        modifier(CircleBorderView(width: width, height: height, color: color))
    }
}
