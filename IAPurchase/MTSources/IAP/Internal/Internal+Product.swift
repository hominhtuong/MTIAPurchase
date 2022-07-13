//
//  Internal+Product.swift
//  IAPurchase
//
//  Created by Minh Tường on 13/07/2022.
//

import Foundation
import StoreKit

extension Internal {
    struct Product {
        private let skProduct: SKProduct

        init(_ skProduct: SKProduct) {
            self.skProduct = skProduct
        }
    }
}
extension Internal.Product: Product {
    var productIdentifier: String {
        return skProduct.productIdentifier
    }
    var price: Decimal {
        return skProduct.price as Decimal
    }
    var localizedTitle: String {
        return skProduct.localizedTitle
    }
    var localizedDescription: String {
        return skProduct.localizedDescription
    }
    var priceLocale: Locale {
        return skProduct.priceLocale
    }
    var isDownloadable: Bool {
        return skProduct.isDownloadable
    }
    var downloadContentLengths: [NSNumber] {
        return skProduct.downloadContentLengths
    }
    var downloadContentVersion: String {
        return skProduct.downloadContentVersion
    }
    var subscriptionPeriod: ProductSubscriptionPeriod? {
        guard let subscriptionPeriod = skProduct.subscriptionPeriod else {
            return nil
        }
        return Internal.ProductSubscriptionPeriod(subscriptionPeriod)
    }
}

extension Internal {
    struct ProductSubscriptionPeriod {
        let numberOfUnits: Int
        let unit: PeriodUnit

        init?(_ period: SKProductSubscriptionPeriod) {
            guard let unit = PeriodUnit(period.unit) else {
                return nil
            }
            self.numberOfUnits = period.numberOfUnits
            self.unit = unit
        }
    }
}
extension Internal.ProductSubscriptionPeriod: ProductSubscriptionPeriod {}

extension PeriodUnit {
    init?(_ unit: SKProduct.PeriodUnit) {
        switch unit {
        case .day: self = .day
        case .week: self = .week
        case .month: self = .month
        case .year: self = .year
        @unknown default: return nil
        }
    }
}
