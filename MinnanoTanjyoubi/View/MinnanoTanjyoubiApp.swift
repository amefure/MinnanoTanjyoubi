//
//  MinnanoTanjyoubiApp.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import FirebaseCore
import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        // Firebase
        FirebaseApp.configure()

        // 通知の許可申請
        AppManager.sharedNotificationRequestManager.requestAuthorization { _ in }

        // 通知デリゲートの登録
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // フォアグラウンドでも通知を有効にする
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .list, .sound]])
    }
}

@main
struct MinnanoTanjyoubiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if rootEnvironment.appLocked {
                    AppLockView()
                        .environmentObject(rootEnvironment)
                } else {
                    RootView()
                        .environmentObject(rootEnvironment)
                }
            }
        }
    }
}
