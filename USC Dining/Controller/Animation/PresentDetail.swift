//
//  PresentDetail.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/25/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

internal class PresentDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // prepare variables
        let containerView = transitionContext.containerView
        guard let _ = transitionContext.viewController(forKey: .from) as? Today, let target = transitionContext.viewController(forKey: .to) as? Detail
            else {return}
        
        // set initial conditions
        containerView.addSubview(target.view)
        target.positionContainer(left: 20.0, right: 20.0, top: selectedCardFrame.origin.y + 20.0, bottom: 0.0)
        target.setHeaderHeight(height: selectedCardFrame.size.height - 40.0)
        target.configureRoundedCorners(shouldRound: true)
        
        // animate to final conditions
        let animations = {
            target.positionContainer(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0)
            target.setHeaderHeight(height: 500)
            target.configureRoundedCorners(shouldRound: false)
        }
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: animations) {(_) in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)}
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
}
