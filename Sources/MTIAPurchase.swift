//
//  MTIAPurchase.swift
//  MTIAPurchase
//
//  Created by Minh Tường on 07/10/2022.
//

import SwiftyStoreKit
import StoreKit

public class MTIAPurchase {
    public static let shared = MTIAPurchase()
    
    public var configs = IAPurchaseConfiguration()
}

//MARK: - Step 1 - Call in AppDelegate
public extension MTIAPurchase {
    func completeTransactions(completion: (([Purchase]) -> Void)? = nil) {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                    
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    fatalError()
                }
            }
            if let completion = completion {
                completion(purchases)
            }
        }
    }
}


//MARK: - Step 2 - Call in Loading Screen
public extension MTIAPurchase {
    func checkPurchase(service: AppleReceiptValidator.VerifyReceiptURLType = .production, completion: @escaping ([PurchaseType]) -> Void) {
        let appleValidator = AppleReceiptValidator(service: service, sharedSecret: MTIAPurchase.shared.configs.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let group = DispatchGroup()
                var purchases: [PurchaseType] = []
                for item in MTIAPurchase.shared.configs.subscriptions {
                    group.enter()
                    if item.isSubscription {
                        self.checkReceipt(productId: item.keyID, receipt: receipt, completion: { status, expiryDate in
                            if status, let expiryDate = expiryDate {
                                purchases.append(.subscription(expiryDate: expiryDate))
                            }
                            
                            group.leave()
                        })
                    } else {
                        self.checkLifeTime(productId: item.keyID, receipt: receipt, completion: { status in
                            if status {
                                purchases.append(.lifeTime)
                            }
                            group.leave()
                        })
                    }
                }
                group.notify(queue: .main, execute: {
                    completion(purchases)
                })
            case .error(let error):
                print("Receipt verification failed: \(error)")
                completion([])
            }
        }
    }
    
    func checkLifeTime(productId: String, receipt: ReceiptInfo, completion: @escaping (Bool) -> Void) {
        let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
        
        switch purchaseResult {
        case .purchased(let receiptItem):
            print("\(productId) is purchased: \(receiptItem)")
            completion(true)
        case .notPurchased:
            print("The user has never purchased \(productId)")
            completion(false)
        }
    }
    
    func checkReceipt(productId: String, receipt: ReceiptInfo, ofType: SubscriptionType = .autoRenewable, completion: @escaping (_ status: Bool, _ expiryDate: Date?) -> Void) {
        let purchaseResult = SwiftyStoreKit.verifySubscription(
            ofType: ofType,
            productId: productId,
            inReceipt: receipt)
            
        let dateFormatter = DateFormatter()
        
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss "
            print("xxx: \(productId) is valid until \(dateFormatter.string(from: expiryDate))\n)\(items)\n")
            completion(true, expiryDate)
        case .expired(let expiryDate, let items):
            print("xxx: \(productId) is expired since \(dateFormatter.string(from: expiryDate))\n\(items)\n")
            completion(false, nil)
        case .notPurchased:
            print("xxx: The user has never purchased \(productId)")
            completion(false, nil)
        }
    }
}

//MARK: - Step 3 - Call when open Subscription Screen
public extension MTIAPurchase {
    func fetchAllProducts(completion: @escaping ([SKProduct]) -> Void) {
        let keys = MTIAPurchase.shared.configs.subscriptions.compactMap({$0.keyID})
        SwiftyStoreKit.retrieveProductsInfo(Set(keys)) { result in
            if let error = result.error {
                print("Error: \(error.localizedDescription)")
            }
            
            let products = Array(result.retrievedProducts.sorted(by: {$0.price.compare($1.price) == ComparisonResult.orderedAscending}))
            completion (products)
        }
    }
    
    ///Purchase
    func purchaseHandle(productID: String, completion: @escaping (Bool, String) -> Void) {
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let product):
                // fetch content from your server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                print("Purchase Success: \(product.productId)")
                completion(true, product.productId)
            case .error(let error):
                var errorDes: String = ""
                switch error.code {
                case .unknown:
                    errorDes = "Unknown error. Please contact support"
                    break
                case .clientInvalid:
                    errorDes = "Not allowed to make the payment"
                    break
                case .paymentCancelled:
                    errorDes = "Payment Cancelled"
                    break
                case .paymentInvalid:
                    errorDes = "The purchase identifier was invalid"
                    break
                case .paymentNotAllowed:
                    errorDes = "The device is not allowed to make the payment"
                    break
                case .storeProductNotAvailable:
                    errorDes = "The product is not available in the current storefront"
                    break
                case .cloudServicePermissionDenied:
                    errorDes = "Access to cloud service information is not allowed"
                    break
                case .cloudServiceNetworkConnectionFailed:
                    errorDes = "Could not connect to the network"
                    break
                case .cloudServiceRevoked:
                    errorDes = "User has revoked permission to use this cloud service"
                    break
                default:
                    errorDes = (error as NSError).localizedDescription
                    break
                }
                print(errorDes)
                completion(false, errorDes)
            }
        }
    }
    
    ///Restore
    func restorePurchase(completion: @escaping (Bool, [String]) -> Void) {
        SwiftyStoreKit.restorePurchases(completion: { results in
            if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                completion(true, results.restoredPurchases.compactMap {$0.productId})
            } else {
                for item in results.restoreFailedPurchases {
                    print("restore fail: \(item.0) - \(item.1 ?? "")")
                }
                completion(false, ["This item was purchased by a different Apple ID. Sign in with that Apple ID and try again"])
            }
        })
    }
}

public extension MTIAPurchase {
    enum PurchaseType: Equatable {
        case lifeTime
        case subscription(expiryDate: Date)
    }
}
