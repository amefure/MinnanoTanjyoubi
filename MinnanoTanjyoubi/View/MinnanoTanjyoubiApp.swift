//
//  MinnanoTanjyoubiApp.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import SwiftUI

@main
struct MinnanoTanjyoubiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if rootEnvironment.appLocked {
                    AppLockView()
                } else {
                    RootView()
                }
            }
        }
    }
}
