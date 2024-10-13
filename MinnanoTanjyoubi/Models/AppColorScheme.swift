//
//  AppColorScheme.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/09/21.
//

import SwiftUI

enum AppColorScheme: String, CaseIterable {
    case original
    case dark
    case light
    case pretty
    case lemon
    case blue
    case modern

    public var name: String {
        switch self {
        case .original:
            return "オリジナル"
        case .dark:
            return "ダーク"
        case .light:
            return "ライト"
        case .pretty:
            return "パステルピンク"
        case .lemon:
            return "レモンイエロー"
        case .blue:
            return "ディープブルー"
        case .modern:
            return "モダンブラック"
        }
    }

    static func getFoundationPrimary(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationPrimary.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2FoundationPrimary.swiftUIColor
        case .light:
            return Asset.Colors.scheme3FoundationPrimary.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4FoundationPrimary.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5FoundationPrimary.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6FoundationPrimary.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7FoundationPrimary.swiftUIColor
        }
    }

    static func getFoundationSub(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationSub.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2FoundationSub.swiftUIColor
        case .light:
            return Asset.Colors.scheme3FoundationSub.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4FoundationSub.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5FoundationSub.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6FoundationSub.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7FoundationSub.swiftUIColor
        }
    }

    static func getThema1(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema1.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema1.swiftUIColor
        case .light:
            return Asset.Colors.scheme3Thema1.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4Thema1.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5Thema1.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6Thema1.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7Thema1.swiftUIColor
        }
    }

    static func getThema2(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema2.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema2.swiftUIColor
        case .light:
            return Asset.Colors.scheme3Thema2.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4Thema2.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5Thema2.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6Thema2.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7Thema2.swiftUIColor
        }
    }

    static func getThema3(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema3.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema3.swiftUIColor
        case .light:
            return Asset.Colors.scheme3Thema3.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4Thema3.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5Thema3.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6Thema3.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7Thema3.swiftUIColor
        }
    }

    static func getThema4(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema4.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema4.swiftUIColor
        case .light:
            return Asset.Colors.scheme3Thema4.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4Thema4.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5Thema4.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6Thema4.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7Thema4.swiftUIColor
        }
    }

    static func getText(_ scheme: AppColorScheme = .light) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Text.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Text.swiftUIColor
        case .light:
            return Asset.Colors.scheme3Text.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme4Text.swiftUIColor
        case .lemon:
            return Asset.Colors.scheme5Text.swiftUIColor
        case .blue:
            return Asset.Colors.scheme6Text.swiftUIColor
        case .modern:
            return Asset.Colors.scheme7Text.swiftUIColor
        }
    }
}
