//
//  PaymentResponse.swift
//  IAPurchase
//
//  Created by Minh Tường on 13/07/2022.
//

import Foundation

public protocol PaymentResponse {
    var state: PaymentState { get }
    var transaction: PaymentTransaction { get }
}

typealias PublicPaymentTransaction = PaymentTransaction
extension Internal {
    internal struct PaymentResponse {
        internal let state: PaymentState
        internal let transaction: PublicPaymentTransaction
    }
}
extension Internal.PaymentResponse: PaymentResponse {}

extension Internal.PaymentResponse: Equatable {
    public static func == (lhs: Internal.PaymentResponse, rhs: Internal.PaymentResponse) -> Bool {
        return lhs.state == rhs.state && lhs.transaction.transactionIdentifier == rhs.transaction.transactionIdentifier
    }
}
