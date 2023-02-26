//
//  ColorAsset.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import UIKit
import SwiftUI

enum ColorAsset {
    
    case foundationColorLight
    case foundationColorDark
    case themaColor1
    case themaColor2
    case themaColor3
    case themaColor4
    
    
    public var thisColor: Color{
        switch self{
        case .foundationColorLight:
            return Color("FoundationColorLight")
        case .foundationColorDark:
            return Color("FoundationColorDark")
        case .themaColor1:
            return Color("ThemaColor1")
        case .themaColor2:
            return Color("ThemaColor2")
        case .themaColor3:
            return Color("ThemaColor3")
        case .themaColor4:
            return Color("ThemaColor4")
        }
    }
}
