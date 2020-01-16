//
//  UpgradeViewController.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/9/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import UIKit
import StoreKit

class UpgradeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(Self.handlePurchaseNotification), name: .MarketPurchaseNotification, object: nil)
    }
    
    @IBAction func subscribeNow(_ sender: UIButton) {
        Market.shared.requestProducts { success, products in
            if success {
                guard let products = products else {return}
                for product in products {
                    if product.productIdentifier == TrojanDiningProducts.MonthlyPro {
                        Market.shared.buy(product: product)
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    @IBAction func restorePurchases(_ sender: UIButton) {
        Market.shared.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        dismiss(animated: true, completion: nil)
    }
}
