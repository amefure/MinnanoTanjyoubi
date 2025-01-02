//
//  ExModifier.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI

/// フォントサイズ
struct FontSize: ViewModifier {
    public let size: CGFloat
    public let bold: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(bold ? .bold : .medium)
    }
}

extension View {
    /// 文字サイズ SSS `Size：10`
    func fontSSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 10, bold: bold))
    }

    /// 文字サイズ SS `Size：12`
    func fontSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 12, bold: bold))
    }

    /// 文字サイズ S `Size：14`
    func fontS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 14, bold: bold))
    }

    /// 文字サイズ M `Size：17`
    func fontM(bold: Bool = false) -> some View {
        modifier(FontSize(size: 17, bold: bold))
    }

    /// 文字サイズ L `Size：20`
    func fontL(bold: Bool = false) -> some View {
        modifier(FontSize(size: 20, bold: bold))
    }

    /// 文字サイズ カスタム
    func fontCustom(size: CGFloat, bold: Bool = false) -> some View {
        modifier(FontSize(size: size, bold: bold))
    }
}

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
