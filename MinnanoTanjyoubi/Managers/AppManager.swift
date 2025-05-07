//
//  AppManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import UIKit

class AppManager: NSObject {
    static let sharedNotificationRequestManager = NotificationRequestManager()
    static let sharedUserDefaultManager = UserDefaultManager()
    static let sharedRemoteConfigManager = RemoteConfigManager()
}
