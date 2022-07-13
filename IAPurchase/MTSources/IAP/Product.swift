//
//  Product.swift
//  IAPurchase
//
//  Created by Minh Tường on 13/07/2022.
//

import Foundation

public protocol Product {
    var productIdentifier: String { get }
    var price: Decimal { get }
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var priceLocale: Locale { get }
    var isDownloadable: Bool { get }
    var downloadContentLengths: [NSNumber] { get }
    var downloadContentVersion: String { get }
    var subscriptionPeriod: ProductSubscriptionPeriod? { get }
}

public protocol ProductSubscriptionPeriod {
    var numberOfUnits: Int { get }
    var unit: PeriodUnit { get }
}

public enum PeriodUnit {
    case day
    case week
    case month
    case year
}
