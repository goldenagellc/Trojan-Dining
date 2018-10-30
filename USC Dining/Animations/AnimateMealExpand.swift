//
//  GrowPresent.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/28/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class AnimateMealExpand: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5.0// seconds
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get references to the view controller being replaced and the one being presented
        // take a snapshot of what the view will look like after transitioning
        print("trying to animate")
        guard
        let fromVC = transitionContext.viewController(forKey: .from) as? TableController_Meals,
        let toVC = transitionContext.viewController(forKey: .to) as? Controller_Meal
        else {return}
        
        // all animations happen inside the container view
        let containerView = transitionContext.containerView
        
        
        // container view has fromVC but not any other views; add them now
        // order matters - last added goes in front
        containerView.addSubview(toVC.mealView)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
//                    snapshot.attachContentTo(finalFrame)
//                    snapshot.roundCorners(toRadius: 0.0)
//                    snapshot.disableShadow()
//                }
                toVC.mealView.mealView.windowToContentTop.constant = 0.0

                //print(toVC.mealView.mealView.windowToContentView.frame)
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
                print("completed")
            }
        )
        
//        self.setNeedsStatusBarAppearanceUpdate()
        
        
    }
    

}
