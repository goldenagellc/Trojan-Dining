//
//  DismissDetail.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/25/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

internal class DismissDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // prepare variables
        let containerView = transitionContext.containerView
        guard let origin = transitionContext.viewController(forKey: .from) as? Detail, let target = transitionContext.viewController(forKey: .to) as? Today
            else {return}
        
        // set initial conditions
        target.view.isHidden = true
        containerView.addSubview(target.view)
        
        // animate to final conditions
        let animations = {
            origin.positionContainer(left: 20.0, right: 20.0, top: self.selectedCardFrame.origin.y + 20.0, bottom: 0.0)
            origin.setHeaderHeight(height: self.selectedCardFrame.size.height - 40.0)
            origin.configureRoundedCorners(shouldRound: true)
        }
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: animations) {(_) in
            target.view.isHidden = false
            origin.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
}
