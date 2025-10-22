//
//  WrapperProduct.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/22.
//

import SwiftUI
import StoreKit

struct WrapperProduct: Identifiable {
    let id: String
    let value: Product
    var isPurchased: Bool
    
    init(product: Product, isPurchased: Bool = false) {
        self.id = product.id
        self.value = product
        self.isPurchased = isPurchased
    }
}
