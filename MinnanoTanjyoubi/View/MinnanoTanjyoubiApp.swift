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
    private let viewModel = RootViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if viewModel.checkAppLock() {
                    /// キーチェーンにパスワードが保存されている場合
                    AppLockView()
                } else {
                    RootView()
                }
            }
        }
    }
}
