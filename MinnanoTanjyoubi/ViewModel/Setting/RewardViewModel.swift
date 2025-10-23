//
//  RewardViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI
import GoogleMobileAds

final class RewardViewModel: ObservableObject {
    @Published var rewardLoaded = false
    @Published var isShowAlert = false
    private var rewardedAd: RewardedAd?
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let rewardService: RewardServiceProtocol
    
    init(
        userDefaultsRepository: UserDefaultsRepository,
        rewardService: RewardServiceProtocol
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.rewardService = rewardService
    }
    
    @MainActor
    func loadReward() async {
        do {
            let ad = try await rewardService.loadAds()
            rewardedAd = ad
            rewardLoaded = true
        } catch {
            // リワード読み込み失敗
            rewardLoaded = false
        }
    }
    
    @MainActor
    func showReward() async {
        
        // 1日1回までしか視聴できないようにする
        guard isPlayFromAcquisitionDate() else {
            isShowAlert = true
            return
        }
        
        // 広告が未読み込みであれば読み込んでから再度表示を試みる
        guard let ad = rewardedAd else {
            await loadReward()
            await showReward()
            return
        }
        do {
            try await rewardService.showAds(ad)
            rewardLoaded = false
            // 計測
            FBAnalyticsManager.loggingAddCapacityEvent()
            // 容量追加
            addCapacity()
            // 1日1回の制限
            registerAcquisitionDate()
        } catch {
            // リワード表示失敗
        }
    }
}

extension RewardViewModel {
  
    // 容量追加
    private func addCapacity() {
        userDefaultsRepository.addCapacity()
    }

    // 容量取得
    func getCapacity() -> Int {
        userDefaultsRepository.getCapacity()
    }

    /// 最終視聴日登録
    private func registerAcquisitionDate() {
        userDefaultsRepository.setAcquisitionDate(nowTime())
    }

    /// 最終視聴日取得
    func getAcquisitionDate() -> String {
        userDefaultsRepository.getAcquisitionDate()
    }

    /// 最終視聴日チェック
    private func isPlayFromAcquisitionDate() -> Bool {
        // 格納してある日付と違えばtrue
        getAcquisitionDate() != nowTime()
    }

    /// 登録する視聴日
    private func nowTime() -> String {
        let dfm = DateFormatUtility(format: .slash)
        return dfm.getString(date: Date())
    }
}
