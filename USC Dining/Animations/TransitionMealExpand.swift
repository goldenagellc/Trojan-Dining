////
////  TransitionMealExpand.swift
////  USC Dining
////
////  Created by Hayden Shively on 10/29/18.
////  Copyright © 2018 Hayden Shively. All rights reserved.
////
//
//import UIKit
//
//class TransitionMealExpand {
//    
//    let animator: UIViewPropertyAnimator
////    let animatorSize: UIViewPropertyAnimator
//    
//    init(params: Params, transitionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator) {
//        
//        let fromVC = transitionContext.viewController(forKey: .from) as! CardTableController
//        let toVC = transitionContext.viewController(forKey: .to) as! CardDetailController
//        let toView = transitionContext.view(forKey: .to)!
//        
//        let containerView = transitionContext.containerView
//        
//        containerView.addSubview(toView)
//        toView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let toViewConstraints = [
//        toView.widthAnchor.constraint(equalToConstant: params.fromCardFrame.width),
//        toView.heightAnchor.constraint(equalToConstant: params.fromCardFrame.height),
//        toView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: params.fromCardFrame.minY),
//        toView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
//        ]
//        NSLayoutConstraint.activate(toViewConstraints)
//        
//        toView.layer.cornerRadius = 16//TODO: Constant
//        
//        params.fromCell.isHidden = true
//        //params.fromCell.resetTransform()
//        
//        containerView.layoutIfNeeded()
//        
//        
//        let animatorSize = UIViewPropertyAnimator(duration: baseAnimator.duration*0.6, curve: .linear) {
//            toViewConstraints[0].constant = containerView.bounds.width
//            toViewConstraints[1].constant = containerView.bounds.height
//            
//            containerView.layoutIfNeeded()
//        }
//        
//        baseAnimator.addAnimations {
//            toViewConstraints[2].constant = 0
//            toView.layer.cornerRadius = 0
//            
//            animatorSize.startAnimation()// TODO: don't nest them like this
//            containerView.layoutIfNeeded()
//        }
//        
//        self.animator = baseAnimator
//    }
//    
//}
