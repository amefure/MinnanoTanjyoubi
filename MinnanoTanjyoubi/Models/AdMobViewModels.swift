//
//  AdMobViewModels.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//


import SwiftUI
import Foundation
import UIKit
import GoogleMobileAds



// MARK: - バナー
private let bannerCode:String = "ca-app-pub-3940256099942544/2934735716"


// MARK: - リワード
private let rewardCode:String = "ca-app-pub-3940256099942544/1712485313"


struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = bannerCode // 自身の広告IDに置き換える
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = windowScene?.windows.first!.rootViewController
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.load(request)
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
      // 特にないのでメソッドだけ用意
    }
}


class Reward: NSObject, ObservableObject ,GADFullScreenContentDelegate {
    // リワード広告を読み込んだかどうか
    @Published  var rewardLoaded: Bool = false
    // リワード広告が格納される
    var rewardedAd: GADRewardedAd? = nil
    
    
    
    override init() {
        super.init()
    }

    // リワード広告の読み込み
    func loadReward() {
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        GADRewardedAd.load(withAdUnitID: rewardCode, request: request, completionHandler: { (ad, error) in
            if let _ = error {
                // 読み込みに失敗しました
                self.rewardLoaded = false
                return
            }
            // 読み込みに成功しました
            self.rewardLoaded = true
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    // 読み込んだリワード広告を表示するメソッド
    func showReward() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        if let ad = rewardedAd {
            ad.present(fromRootViewController: rootVC!, userDidEarnRewardHandler: {
                // 報酬を獲得
                self.rewardLoaded = false
            })
        } else {
            self.rewardLoaded = false
            self.loadReward()
        }
    }
}

