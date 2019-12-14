//
//  FoodDetailController.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit
import AuthenticationServices

class FoodDetailController: UIViewController {

    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var allergenSubtitle: UILabel!
    @IBOutlet weak var starStackView: StarRatingView!
    
    public var food: Food? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let name = food?.name else {return}
        let repeated = String(repeating: name.uppercased() + " ", count: 200)
        foodTitle.text = repeated
        
        allergenSubtitle.text = "  Attributes: " + (food?.attributes.joined(separator: ", ") ?? "None") + "  "
        allergenSubtitle.textColor = UIColor(white: 1 - (UIColor.label.cgColor.components?[0] ?? CGFloat(0)), alpha: 1.0)
        
        starStackView.addStarButtonCallback(onStarButtonTap)
    }
    
    private func onStarButtonTap(_ rating: Int) {
        if TrojanDiningUser.shared.isSignedInWithApple != .authorized {
            let controller = ASAuthorizationController(authorizationRequests: [TrojanDiningUser.shared.signInWithAppleRequest()])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
        // TODO call Firestore to update rating
    }
}

extension FoodDetailController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            TrojanDiningUser.shared.signInWithApple(using: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //TODO handle errors
        print("FoodDetailController: 'Sign in with Apple' flow failed.")
    }
}

extension FoodDetailController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
