//
//  AppDelegate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/03.
//

import FirebaseCore
import Foundation
import GoogleMobileAds
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        // Firebase
        FirebaseApp.configure()

        // 通知申請
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }

        return true
    }
}
