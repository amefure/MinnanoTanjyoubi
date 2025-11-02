//
//  MinnanoTanjyoubiApp.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import Foundation
import GoogleMobileAds
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // AdMob
        MobileAds.shared.start(completionHandler: nil)

        // Firebaseの初期化はdidFinishLaunchingWithOptionsだと
        // DIContainerのインスタンス化までに間に合わないので
        // RemoteConfigManagerのイニシャライザで行う
        // FirebaseApp.configure()

        // 通知デリゲートの登録
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // フォアグラウンドでも通知を有効にする
    nonisolated func userNotificationCenter(
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

    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if rootEnvironment.state.appLocked {
                    AppLockView()
                } else {
                    RootView()
                }
            }.onAppear { rootEnvironment.onAppear() }
        }
    }
}
