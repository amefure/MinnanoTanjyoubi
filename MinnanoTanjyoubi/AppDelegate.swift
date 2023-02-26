//
//  AppDelegate.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/03.
//

import Foundation
import UIKit
import GoogleMobileAds
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Firebase
        FirebaseApp.configure()
        
        // 通知申請
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }

        return true
    }
}
