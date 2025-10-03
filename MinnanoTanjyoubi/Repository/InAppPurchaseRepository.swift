//
//  InAppPurchaseRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/01/02.
//

/// CombineではSwift6対応(Sendable準拠))がされていないため`@preconcurrency`で制限を緩くする
@preconcurrency import Combine
import StoreKit
import SwiftUI

actor InAppPurchaseRepository {
    /// `課金アイテムID`
    static let REMOVE_ADS_ID = ProductItem.removeAds.id
    static let UNLOCK_STORAGE_ID = ProductItem.unlockStorage.id

    /// 課金アイテム配列
    @MainActor
    var products: AnyPublisher<[Product], Never> {
        _products.eraseToAnyPublisher()
    }

    @MainActor
    private let _products = CurrentValueSubject<[Product], Never>([])

    /// 購入済み課金アイテム配列
    @MainActor
    var purchasedProducts: AnyPublisher<[Product], Never> {
        _purchasedProducts.eraseToAnyPublisher()
    }

    @MainActor
    private let _purchasedProducts = CurrentValueSubject<[Product], Never>([])

    /// 購入中
    @MainActor
    var isPurchasing: AnyPublisher<Bool, Never> {
        _isPurchasing.eraseToAnyPublisher()
    }

    @MainActor
    private let _isPurchasing = PassthroughSubject<Bool, Never>()

    /// 購入エラー
    @MainActor
    var fetchError: AnyPublisher<Bool, Never> {
        _fetchError.eraseToAnyPublisher()
    }

    @MainActor
    private let _fetchError = PassthroughSubject<Bool, Never>()

    /// 購入エラー
    @MainActor
    var purchaseError: AnyPublisher<Bool, Never> {
        _purchaseError.eraseToAnyPublisher()
    }

    @MainActor
    private let _purchaseError = PassthroughSubject<Bool, Never>()

    ///
    private var updateListenerTask: Task<Void, Error>?

    func startListen() {
        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts()

            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    /// 購入済みプロダクトかどうか
    @MainActor
    func isPurchased(_ productId: String) -> Bool {
        _purchasedProducts.value.contains { $0.id == productId }
    }

    /// 課金アイテムを取得する
    private func requestProducts() async {
        do {
            let productIdentifiers = [Self.REMOVE_ADS_ID, Self.UNLOCK_STORAGE_ID]
            let products = try await Product.products(for: productIdentifiers)
            let sorted = products.sorted { $0.price < $1.price }
            await MainActor.run {
                _products.send(sorted)
            }
        } catch {
            await MainActor.run {
                // 課金アイテム取得失敗
                _fetchError.send(true)
            }
        }
    }

    /// 購入処理
    @MainActor
    func purchase(product: Product) async {
        _isPurchasing.send(true)
        do {
            // 購入
            let result = try await product.purchase()
            switch result {
            // 成功
            case let .success(verificationResult):
                // レシート検証結果
                switch verificationResult {
                case .verified:
                    // 検証成功
                    let transaction = try await checkVerified(verificationResult)
                    // 課金アイテム情報更新
                    await updateCustomerProductStatus()
                    // トランザクションを明示的に終了
                    await transaction.finish()
                    _isPurchasing.send(false)
                case .unverified:
                    // 検証失敗エラー
                    await handlePurchaseError()
                    _isPurchasing.send(false)
                }
            // 購入中 , ユーザーキャンセル
            case .pending, .userCancelled:
                _isPurchasing.send(false)
            @unknown default:
                _isPurchasing.send(false)
            }
        } catch {
            _isPurchasing.send(false)
            // エラー
            await handlePurchaseError()
        }
    }

    /// 購入エラー
    private func handlePurchaseError() {
        _purchaseError.send(true)
    }

    /// 課金アイテムの更新を観測
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)

                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                } catch {
                    // 検証失敗エラー
                }
            }
        }
    }

    /// JWS検証が正常に行われているかどうか
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.unknown
        case let .verified(safe):
            return safe
        }
    }

    /// 復元処理
    @MainActor
    func restore() {
        Task {
            do {
                try await AppStore.sync()
            } catch {
                // 復元失敗
            }
        }
    }

    /// 購入済みアイテム履歴情報を取得
    private func updateCustomerProductStatus() async {
        var purchasedItems: [Product] = []
        // 現在の購入情報を取得する
        // Consumable(消耗型は取得できない)
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                switch transaction.productType {
                // 非消耗型
                case .nonConsumable:
                    if let products = _products.value.first(where: { $0.id == transaction.productID }) {
                        purchasedItems.append(products)
                    }
                default:
                    break
                }
            } catch {
                // 検証失敗エラー
            }
        }
        _purchasedProducts.send(purchasedItems)
    }
}
