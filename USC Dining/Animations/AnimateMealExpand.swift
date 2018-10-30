//
//  GrowPresent.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/28/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class AnimateMealExpand: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let params: Params
    private let springAnimator: UIViewPropertyAnimator
    private var transitionDriver: TransitionMealExpand?
    
    init(params: Params) {
        self.params = params
        self.springAnimator = expandingSpringAnimator(params: params)
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.springAnimator.duration// seconds
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        return transitionDriver!.animator
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = TransitionMealExpand(params: self.params, transitionContext: transitionContext, baseAnimator: self.springAnimator)
        
        self.interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }
    
    
    
    

}
