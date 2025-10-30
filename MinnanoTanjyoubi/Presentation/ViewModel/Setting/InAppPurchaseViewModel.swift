//
//  InAppPurchaseViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import Combine
import StoreKit
import SwiftUI

@Observable
final class InAppPurchaseState {
    /// 取得エラー
    fileprivate(set) var fetchError: Bool = false
    /// 購入エラー
    var isShowPurchaseError: Bool = false
    /// 復元成功
    var isShowSuccessRestoreAlert: Bool = false
    /// 復元エラー
    var isShowFailedRestoreAlert: Bool = false
    /// 購入中アイテムID
    fileprivate(set) var isPurchasingId: String = ""
    /// 課金アイテム
    fileprivate(set) var products: [WrapperProduct] = []

    /// この画面を表示してから課金が行われたかどうか
    /// `RootEnviroment`側でフラグを更新するため
    fileprivate(set) var didPurchase: Bool = false
}

final class InAppPurchaseViewModel {
    var state = InAppPurchaseState()

    private var cancellables: Set<AnyCancellable> = []

    private let userDefaultsRepository: UserDefaultsRepository
    private let inAppPurchaseRepository: InAppPurchaseRepository

    private var purchaseTask: Task<Void, Never>?

    init(
        userDefaultsRepository: UserDefaultsRepository,
        inAppPurchaseRepository: InAppPurchaseRepository
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.inAppPurchaseRepository = inAppPurchaseRepository
    }

    @MainActor
    func onAppear() {
        FBAnalyticsManager.loggingScreen(screen: .InAppPurchaseScreen)

        Task {
            await inAppPurchaseRepository.startListen()
        }

        // 課金アイテム取得
        inAppPurchaseRepository.products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                guard let self else { return }
                state.products = products.map { WrapperProduct(product: $0) }
            }.store(in: &cancellables)

        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] purchasedProducts in
                guard let self else { return }

                for product in state.products {
                    guard purchasedProducts.contains(where: { $0.id == product.id }) else { continue }
                    guard let index = state.products.firstIndex(where: { $0.id == product.id }) else { continue }
                    state.products[index].isPurchased = true
                }

                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockStorage = inAppPurchaseRepository.isPurchased(ProductItem.unlockStorage.id)
                // ローカルフラグを更新(購入済み or 未購入)
                userDefaultsRepository.setPurchasedRemoveAds(removeAds)
                userDefaultsRepository.setPurchasedUnlockStorage(unlockStorage)
            }.store(in: &cancellables)

        // 購入中
        inAppPurchaseRepository.isPurchasing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in
                guard let self else { return }
                // 購入中ではなくなったらIDをリセット
                if !flag {
                    state.isPurchasingId = ""
                }
            }.store(in: &cancellables)

        // 取得エラー
        inAppPurchaseRepository.fetchError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in
                guard let self else { return }
                state.fetchError = flag
            }.store(in: &cancellables)

        // 購入エラー
        inAppPurchaseRepository.purchaseError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in
                guard let self else { return }
                state.isShowPurchaseError = flag
            }.store(in: &cancellables)
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        purchaseTask?.cancel()
    }

    /// 購入開始
    @MainActor
    func purchase(product: Product) {
        state.isPurchasingId = product.id
        purchaseTask = Task {
            await inAppPurchaseRepository.purchase(product: product)
            // 課金に成功したらフラグを立てておく
            state.didPurchase = true
        }
    }

    /// 復帰処理
    @MainActor
    func restore() {
        Task {
            do {
                try await inAppPurchaseRepository.restore()
                state.isShowSuccessRestoreAlert = true
            } catch {
                state.isShowFailedRestoreAlert = true
            }
        }
    }
}
