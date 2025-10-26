//
//  PopUpPosition.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/19.
//

import SwiftUI

enum PopUpPosition {
    case topLeft
    case topRight

    case bottomLeft
    case bottomMiddle
    case bottomRight

    var next: PopUpPosition? {
        switch self {
        case .topLeft:
            nil
        case .topRight:
            .topLeft
        case .bottomLeft:
            .topRight
        case .bottomMiddle:
            .bottomLeft
        case .bottomRight:
            .bottomMiddle
        }
    }
}
