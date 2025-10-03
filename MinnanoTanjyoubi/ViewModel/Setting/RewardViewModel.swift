//
//  RewardViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI

class RewardViewModel {
    private let dfm = DateFormatUtility()

    // 容量追加
    func addCapacity() {
        AppManager.sharedUserDefaultManager.addCapacity()
    }

    // 容量取得
    func getCapacity() -> Int {
        AppManager.sharedUserDefaultManager.getCapacity()
    }

    /// 最終視聴日登録
    func registerAcquisitionDate() {
        AppManager.sharedUserDefaultManager.setAcquisitionDate(nowTime())
    }

    /// 最終視聴日取得
    func getAcquisitionDate() -> String {
        AppManager.sharedUserDefaultManager.getAcquisitionDate()
    }

    /// 最終視聴日チェック
    func checkAcquisitionDate() -> Bool {
        // 格納してある日付と違えばtrue
        getAcquisitionDate() != nowTime()
    }

    /// 登録する視聴日
    private func nowTime() -> String {
        return dfm.getSlashString(date: Date())
    }
}
