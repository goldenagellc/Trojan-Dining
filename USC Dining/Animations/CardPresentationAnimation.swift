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
        let maximumDuration: TimeInterval = 0.9
        let duration: TimeInterval = nominalDuration + (maximumDuration - nominalDuration)*TimeInterval(max(0, distanceToBounce)/UIScreen.main.bounds.height)

        return (duration, damping)
//        let timing = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0.0, dy: 0.0))
//        return UIViewPropertyAnimator(duration: duration, timingParameters: timing)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5.0//spring.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {return}

        if let newCardVC = toVC as? CardDetailController {
            print(true)
            newCardVC.cardView.label_title.text = params.fromCell.cardView.label_title.text
            newCardVC.cardView.label_subtitle.text = params.fromCell.cardView.label_subtitle.text
            newCardVC.cardView.label_description.text = params.fromCell.cardView.label_description.text
            newCardVC.cardView.image.image = params.fromCell.cardView.image.image
        }


        container.addSubview(toView)
        params.fromCell.isHidden = true

//        let cardVerticalAnchor: NSLayoutConstraint = toView.topAnchor.constraint(equalTo: container.topAnchor, constant: params.fromCardFrame.minY)
        let cardHorizontAnchor: NSLayoutConstraint = toView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        print(params.fromCardFrame.width)
        let cardWidthConstraint: NSLayoutConstraint = toView.widthAnchor.constraint(equalToConstant: params.fromCardFrame.width)
        let cardHeighConstraint: NSLayoutConstraint = toView.heightAnchor.constraint(equalToConstant: params.fromCardFrame.height)
        NSLayoutConstraint.activate([/*cardVerticalAnchor,*/ cardHorizontAnchor, cardWidthConstraint, cardHeighConstraint])

        container.layoutIfNeeded()

        print(params.fromCardFrame.width)
        print(toView.frame.width)


        let duration = transitionDuration(using: transitionContext)
//        UIView.animate(withDuration: duration) {
//            cardVerticalAnchor.constant = 0
//            container.layoutIfNeeded()
//        }

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: spring.damping, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            cardWidthConstraint.constant = container.bounds.width
            cardHeighConstraint.constant = container.bounds.height
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
