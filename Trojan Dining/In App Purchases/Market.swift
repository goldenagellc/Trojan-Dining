//
//  Market.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/15/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String

extension Notification.Name {
    static let MarketPurchaseNotification = Notification.Name("MarketPurchaseNotification")
}

public class Market: NSObject {
    
    public private(set) static var shared: Market = {
        return Market(thatSells: TrojanDiningProducts.identifiers)
    }()
    
    private let products: Set<ProductIdentifier>
    private var productsPurchased: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest? = nil
    private var completionHandler: ((Bool, [SKProduct]?) -> Void)? = nil
    
    private init(thatSells products: Set<ProductIdentifier>) {
        self.products = products
        productsPurchased = self.products.filter({UserDefaults.standard.bool(forKey: $0)})
        
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}

extension Market {
    public func requestProducts(_ completion: @escaping (Bool, [SKProduct]?) -> Void) {
        productsRequest?.cancel()
        completionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: products)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buy(product: SKProduct) {
        print("Log @Market: Buying \(product.productIdentifier)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ product: ProductIdentifier) -> Bool {
        return productsPurchased.contains(product)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension Market: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let skProducts = response.products
        completionHandler?(true, skProducts)
        
        productsRequest = nil
        completionHandler = nil
        
        for p in skProducts {
            print("Log @Market: Found SKProduct - \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error @Market: Failed to load list of SKProducts - \(error.localizedDescription)")
        completionHandler?(false, nil)
        
        productsRequest = nil
        completionHandler = nil
    }
}

extension Market: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Log @Market: Completing transaction")
        deliverPurchaseNotification(for: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let product = transaction.original?.payment.productIdentifier else {return}
        
        print("Log @Market: Restoring purchase")
        deliverPurchaseNotification(for: product)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("Log @Market: Purchase did fail")
        if let error = transaction.error as NSError?, let description = transaction.error?.localizedDescription, error.code != SKError.paymentCancelled.rawValue {
            print("----> \(description)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotification(for identifier: String?) {
        guard let identifier = identifier else {return}
        
        productsPurchased.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .MarketPurchaseNotification, object: identifier)
    }
}


public struct TrojanDiningProducts {
    public static let MonthlyPro = "info.haydenshively.trojan_dining.monthly_pro"
    
    public static let identifiers: Set<ProductIdentifier> = [MonthlyPro]
}

func resourceNameForProductIdentifier(_ product: ProductIdentifier) -> String? {
    return product.components(separatedBy: ".").last
}
