//
//  WrapperProduct.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/22.
//

import StoreKit
import SwiftUI

struct WrapperProduct: Identifiable {
    let id: String
    let value: Product
    var isPurchased: Bool

    init(product: Product, isPurchased: Bool = false) {
        id = product.id
        value = product
        self.isPurchased = isPurchased
    }
}
