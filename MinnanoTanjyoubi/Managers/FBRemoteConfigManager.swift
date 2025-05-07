//
//  FBRemoteConfigManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/05/07.
//

import Combine
import FirebaseRemoteConfig

class RemoteConfigManager {
    private let remoteConfig: RemoteConfig

    public var showReviewPopupVersion: AnyPublisher<Int, Never> {
        _showReviewPopupVersion.eraseToAnyPublisher()
    }

    private var _showReviewPopupVersion = CurrentValueSubject<Int, Never>(0)

    init() {
        // RemoteConfigインスタンスを取得
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        // 最小フェッチ間隔 開発環境では0(制限なし)を指定
        settings.minimumFetchInterval = 0
        // 設定を反映
        remoteConfig.configSettings = settings
    }

    public func initialize() {
        fetchRemoteConfig()
    }

    /// リモートサーバーから最新の設定値を取得してremoteConfigインスタンスに反映
    private func fetchRemoteConfig() {
        remoteConfig.fetch { [weak self] status, error in
            guard let self else { return }
            if status == .success {
                self.remoteConfig.activate(completion: nil)
                applyShowReviewPopupVersion()
            } else {
                #if DEBUG
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                #endif
            }
        }
    }

    /// `SHOW_REVIEW_POPUP_KEY`設定値を取得し公開
    private func applyShowReviewPopupVersion() {
        let version = Int(truncating: remoteConfig[RemoteConfigManager.SHOW_REVIEW_POPUP_VERSION_KEY].numberValue)
        _showReviewPopupVersion.send(version)
    }

    private static let SHOW_REVIEW_POPUP_VERSION_KEY = "show_review_popup_version"
}
