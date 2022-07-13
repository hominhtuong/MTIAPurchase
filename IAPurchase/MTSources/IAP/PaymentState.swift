//
//  PaymentState.swift
//  IAPurchase
//
//  Created by Minh Tường on 13/07/2022.
//

import Foundation

public enum PaymentState: Equatable {
    case purchased
    case deferred
    case restored
}
