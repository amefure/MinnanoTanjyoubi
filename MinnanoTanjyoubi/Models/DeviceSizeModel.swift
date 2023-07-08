//
//  DeviceSizeModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/17.
//

import UIKit

class DeviceSizeModel {
    static let deviceWidth = UIScreen.main.bounds.width
    static let deviceHeight = UIScreen.main.bounds.height

    static var isSESize: Bool {
        if deviceWidth < 400 {
            return true
        } else {
            return false
        }
    }

    static var isiPadSize: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}
