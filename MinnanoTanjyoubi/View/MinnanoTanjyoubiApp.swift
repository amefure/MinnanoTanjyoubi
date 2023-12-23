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

    @ObservedObject private var rootEnvironment = RootEnvironment()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if KeyChainRepository().getData().count == 4 {
                    /// キーチェーンにパスワードが保存されている場合
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
