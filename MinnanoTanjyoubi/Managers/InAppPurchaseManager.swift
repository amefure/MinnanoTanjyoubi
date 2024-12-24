//
//  InAppPurchaseManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import StoreKit
import SwiftUI

class InAppPurchaseManager: NSObject, SKProductsRequestDelegate {
    /// 課金アイテムを取得する
    public func fetchProducts() {
        print("-----課金アイテムを取得開始")
        let productIDs: Set<String> = [""]
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }

    /// 課金アイテムを取得した結果
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("-----課金アイテムを取得")
        // 不正な課金アイテムがないかチェック
        guard response.invalidProductIdentifiers.isEmpty else { return }
        for product in response.products {
            print("Product found: \(product.localizedTitle) - \(product.price)")
        }
    }

    func restore() {
        // SKPaymentQueue.default().restoreCompletedTransactions()
        Task {
            do {
                try await AppStore.sync()
                let verificationResult = await Transaction.currentEntitlement(for: "AppStoreConnectで設定したIDを入力")
                if case .verified = verificationResult {
                    // 復元が成功した場合の処理
                } else {
                    // 復元が失敗した場合の処理
                }
            } catch {
                // 復元が失敗した場合の処理
            }
        }
    }
}

class PurchaseManager: NSObject, SKPaymentTransactionObserver {
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful!")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Purchase failed: \(transaction.error?.localizedDescription ?? "Unknown error")")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
