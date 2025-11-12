//
//  AdMobCommonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

// ビルド番号はインクリメントしなくてOK
// bundle exec fastlane release
// リソース生成コマンド
// swiftgen config run

// Test:ca-app-pub-3940256099942544~1458002511

// App :

// Test
// private let bannerCode: String = "ca-app-pub-3940256099942544/2934735716"

// App
private let bannerCode: String = ""

// Test
// private let rewardCode: String = "ca-app-pub-3940256099942544/1712485313"

// App
private let rewardCode: String = ""

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context _: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = bannerCode // 自身の広告IDに置き換える
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootVC = windowScene?.windows.first?.rootViewController else { return banner }
        banner.rootViewController = rootVC
        let request = Request()
        request.scene = windowScene
        banner.load(request)
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_: BannerView, context _: Context) {
        // 特にないのでメソッドだけ用意
    }
}

/// インタースティシャルと共通にしたかったが
/// `RewardedAd`などが共通のプロトコルに準拠していなさそうなのでNG
protocol RewardServiceProtocol {
    @MainActor
    func loadAds() async throws -> RewardedAd
    @MainActor
    func showAds(_ ad: RewardedAd) async throws
}

final class RewardService: NSObject, RewardServiceProtocol, FullScreenContentDelegate {
    ///  広告をロード
    @MainActor
    func loadAds() async throws -> RewardedAd {
        let request = Request()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let ad = try await RewardedAd.load(with: rewardCode, request: request)
        ad.fullScreenContentDelegate = self
        return ad
    }

    /// 広告を取得
    @MainActor
    func showAds(_ ad: RewardedAd) async throws {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootVC = windowScene?.windows.first?.rootViewController else { return }

        try await withCheckedThrowingContinuation { continuation in
            ad.present(from: rootVC) {
                // 広告視聴完了
                continuation.resume()
            }
        }
    }
}
