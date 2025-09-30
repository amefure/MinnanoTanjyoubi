//
//  ExModifier.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI

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
            .foregroundColor(scheme.thema1)
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

extension View {
    /// モディファイアをif文で分岐して有効/無効を切り替えることができる拡張
    ///
    /// - Parameters:
    ///   - condition: 有効/無効の条件
    ///   - apply: 有効時に適応させたいモディファイア

    /// Example:
    /// ```
    /// .if(condition) { view in
    ///     view.foregroundStyle(.green)
    /// }
    /// ```
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
