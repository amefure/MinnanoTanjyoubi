//
//  DeviceSizeUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import UIKit

@MainActor
class DeviceSizeUtility {
    static var deviceWidth: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.width
    }

    static var deviceHeight: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.height
    }

    static var isSESize: Bool { deviceWidth < 400 }

    static var isiPadSize: Bool { UIDevice.current.userInterfaceIdiom == .pad }
}
