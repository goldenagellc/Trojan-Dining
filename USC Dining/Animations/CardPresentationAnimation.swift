//
//  CardPresentationAnimation.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/2/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardPresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    let params: CardTransitioningDelegate.Params
    let spring: (duration: TimeInterval, damping: CGFloat)

    init(params: CardTransitioningDelegate.Params) {
        self.params = params
        self.spring = CardPresentationAnimation.createSpring(startingAt: params.fromCardFrame)
        super.init()
    }

    static func createSpring(startingAt frame: CGRect) -> (TimeInterval, CGFloat) {
        let yPosition = frame.minY
        let distanceToBounce = abs(yPosition)

        let extentToBounce = yPosition < 0.0 ? frame.height : UIScreen.main.bounds.height
        let dampingKeyframe: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampingKeyframe*(distanceToBounce/extentToBounce)

        let nominalDuration: TimeInterval = 0.5
        let maximumDuration: TimeInterval = 1.1
        let duration: TimeInterval = nominalDuration + (maximumDuration - nominalDuration)*TimeInterval(max(0, distanceToBounce)/UIScreen.main.bounds.height)

        return (duration, damping)
//        let timing = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0.0, dy: 0.0))
//        return UIViewPropertyAnimator(duration: duration, timingParameters: timing)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return spring.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
        let toVC = transitionContext.viewController(forKey: .to) as? CardDetailController,
        let toView = transitionContext.view(forKey: .to)
        else {return}
        let container = transitionContext.containerView

        // Make sure data matches
        toVC.setData(toCard: params.fromCell.getData()!)

        // Create a temporary view for animation
        let animatedView = UIView()
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animatedView)
        // Constrain it to its container
        let animatedViewConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animatedView.widthAnchor.constraint(equalToConstant: container.bounds.width),
            animatedView.heightAnchor.constraint(equalToConstant: container.bounds.height)
        ]
        NSLayoutConstraint.activate(animatedViewConstraints)
        let animatedViewVerticalConstraint: NSLayoutConstraint = animatedView.topAnchor.constraint(equalTo: container.topAnchor, constant: params.fromCardFrame.minY)
        animatedViewVerticalConstraint.isActive = true

        // Add the destination view the temporary animated view
        animatedView.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        toView.layer.cornerRadius = 16
        // Constrain it to the animated view
        let toViewConstraints = [
            toView.centerXAnchor.constraint(equalTo: animatedView.centerXAnchor),
            toView.widthAnchor.constraint(equalToConstant: params.fromCardFrame.width),
            toView.heightAnchor.constraint(equalToConstant: params.fromCardFrame.height)
        ]
        NSLayoutConstraint.activate(toViewConstraints)
        let toViewVerticalConstraint = toView.topAnchor.constraint(equalTo: animatedView.topAnchor, constant: 0)
        toViewVerticalConstraint.isActive = true


        params.fromCell.isHidden = true
        params.fromCell.transform = .identity
        container.layoutIfNeeded()



        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            toViewConstraints[1].constant = animatedView.bounds.width
            toViewConstraints[2].constant = animatedView.bounds.height
            toView.layer.cornerRadius = 0
            toVC.setNeedsStatusBarAppearanceUpdate()
            container.layoutIfNeeded()
        }

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: spring.damping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            animatedViewVerticalConstraint.constant = 0.0
            container.layoutIfNeeded()
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        if animator == nil {animator = Animator(params, transitionContext, spring: spring)}
//        return animator!
//    }
//
//    func animationEnded(_ transitionCompleted: Bool) {
//        animator = nil
//    }
//
//    private final class Animator: UIViewPropertyAnimator {
//        init(_ params: CardTransitioningDelegate.Params, _ transitionContext: UIViewControllerContextTransitioning, spring: UIViewPropertyAnimator) {
//
//            let container = transitionContext.containerView
//
//            let fromVC = transitionContext.viewController(forKey: .from) as! CardTableController
//            let toVC = transitionContext.viewController(forKey: .to) as! CardDetailController
//            let toView = transitionContext.view(forKey: .to)!
//
//            UIViewImplicitlyAnimating()
//        }
//    }

}
