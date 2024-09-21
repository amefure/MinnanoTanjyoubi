//
//  AppColorScheme.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/09/21.
//

import SwiftUI

enum AppColorScheme {
    case original
    
    
    static func getFoundationPrimary(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationPrimary.swiftUIColor
        }
    }
    
    static func getFoundationSub(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1FoundationSub.swiftUIColor
        }
    }
    
    static func getThema1(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema1.swiftUIColor
        }
    }
    
    static func getThema2(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema2.swiftUIColor
        }
    }
    
    static func getThema3(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema3.swiftUIColor
        }
    }
    
    static func getThema4(scheme: AppColorScheme = .original) -> Color {
        switch scheme {
        case .original:
            return Asset.Colors.scheme1Thema4.swiftUIColor
        }
    }
}


 
