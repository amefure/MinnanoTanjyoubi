//
//  RewardViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import SwiftUI

class RewardViewModel {
    private let userDefaultsRepository: UserDefaultsRepository

    private let dfm = DateFormatUtility()

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    // 容量追加
    public func addCapacity() {
        let current = getCapacity()
        let capacity = current + AdsConfig.ADD_CAPACITY
        userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: capacity)
    }

    // 容量取得
    public func getCapacity() -> Int {
        let capacity = userDefaultsRepository.getIntData(key: UserDefaultsKey.LIMIT_CAPACITY)
        if capacity < AdsConfig.INITIAL_CAPACITY {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LIMIT_CAPACITY, value: AdsConfig.INITIAL_CAPACITY)
            return AdsConfig.INITIAL_CAPACITY
        } else {
            return capacity
        }
    }

    /// 最終視聴日登録
    public func registerAcquisitionDate() {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE, value: nowTime())
    }

    /// 最終視聴日取得
    public func getAcquisitionDate() -> String {
        userDefaultsRepository.getStringData(key: UserDefaultsKey.LAST_ACQUISITION_DATE)
    }

    /// 最終視聴日チェック
    public func checkAcquisitionDate() -> Bool {
        // 格納してある日付と違えばtrue
        getAcquisitionDate() != nowTime()
    }

    /// 登録する視聴日
    private func nowTime() -> String {
        return dfm.getSlashString(date: Date())
    }
}
