//
//  InAppPurchaseViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import Combine
import StoreKit
import SwiftUI

class InAppPurchaseViewModel: ObservableObject {
    /// 取得エラー
    @Published var fetchError: Bool = false
    /// 購入エラー
    @Published var purchaseError: Bool = false
    /// 課金アイテム
    @Published private(set) var products: [Product] = []

    private var cancellables: Set<AnyCancellable> = []

    private let inAppPurchaseRepository: InAppPurchaseRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        inAppPurchaseRepository = repositoryDependency.inAppPurchaseRepository
    }

    public func onAppear() {
        // 課金アイテム取得
        inAppPurchaseRepository.products.sink { [weak self] products in
            guard let self else { return }
            self.products = products
        }.store(in: &cancellables)

        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockStorage = inAppPurchaseRepository.isPurchased(ProductItem.unlockStorage.id)
                // ローカルフラグを更新(購入済み or 未購入)
                AppManager.sharedUserDefaultManager.setPurchasedRemoveAds(removeAds)
                AppManager.sharedUserDefaultManager.setPurchasedUnlockStorage(unlockStorage)
            }.store(in: &cancellables)

        // 取得エラー
        inAppPurchaseRepository.fetchError.sink { [weak self] flag in
            guard let self else { return }
            self.fetchError = flag
        }.store(in: &cancellables)

        // 購入エラー
        inAppPurchaseRepository.purchaseError.sink { [weak self] flag in
            guard let self else { return }
            self.purchaseError = flag
        }.store(in: &cancellables)
    }

    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    /// 購入済みプロダクトかどうか
    public func isPurchased(_ productId: String) -> Bool {
        inAppPurchaseRepository.isPurchased(productId)
    }

    public func purchase(product: Product) {
        Task {
            await inAppPurchaseRepository.purchase(product: product)
        }
    }

    public func restore() {
        inAppPurchaseRepository.restore()
    }
}
