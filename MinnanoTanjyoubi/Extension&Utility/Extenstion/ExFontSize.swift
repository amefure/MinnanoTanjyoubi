//
//  ExFontSize.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/09/09.
//

import SwiftUI

/// フォントサイズ
struct FontSize: ViewModifier {
    let size: CGFloat
    let bold: Bool
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
