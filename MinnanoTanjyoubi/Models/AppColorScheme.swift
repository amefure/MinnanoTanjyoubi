//
//  AppColorScheme.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/09/21.
//

import SwiftUI

enum AppColorScheme {
    case original
    case dark
    case pretty

    static func getFoundationPrimary(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationPrimary.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2FoundationPrimary.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3FoundationPrimary.swiftUIColor
        }
    }

    static func getFoundationSub(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationSub.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2FoundationSub.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3FoundationSub.swiftUIColor
        }
    }

    static func getThema1(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema1.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema1.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3Thema1.swiftUIColor
        }
    }

    static func getThema2(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema2.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema2.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3Thema2.swiftUIColor
        }
    }

    static func getThema3(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema3.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema3.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3Thema3.swiftUIColor
        }
    }

    static func getThema4(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema4.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Thema4.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3Thema4.swiftUIColor
        }
    }

    static func getText(scheme: AppColorScheme = .pretty) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Text.swiftUIColor
        case .dark:
            return Asset.Colors.scheme2Text.swiftUIColor
        case .pretty:
            return Asset.Colors.scheme3Text.swiftUIColor
        }
    }
}
