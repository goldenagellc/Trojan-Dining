//
//  CardTransitioningDelegate.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/2/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameBeforeTransform: CGRect
        let fromCell: CardTableCell
    }
}

//    let params: Params
//
//    init(params: Params) {
//        self.params = params
//        print("transition inited")
//        super.init()
//    }
//
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        print("sdfb")
//        return CardPresentationController(presentedViewController: presented, presenting: presenting)
//    }
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        print("reacfvhedouhrv")
//        return CardPresentationAnimation(params: params)
//    }
//
////    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
////        return nil
////    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil//CardDismissalAnimation(params: params)
//    }
//
////    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
////        return nil
////    }
//}
//
//class CardPresentationController: UIPresentationController {
//
//    private lazy var blurView = UIVisualEffectView(effect: nil)
//
//    override func presentationTransitionWillBegin() {
//        guard let container = containerView else {return}
//
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(blurView)
//        blurView.edges(to: container)
//        blurView.alpha = 0.0
//
//        presentingViewController.beginAppearanceTransition(false, animated: false)
//        guard let coordinator = presentingViewController.transitionCoordinator else {return}
//        coordinator.animate(alongsideTransition: {context in
//            UIView.animate(withDuration: 0.5) {// TODO constant
//                self.blurView.effect = UIBlurEffect(style: .light)
//                self.blurView.alpha = 1.0
//            }
//        }, completion: nil)
//    }
//
//    override func presentationTransitionDidEnd(_ completed: Bool) {presentingViewController.endAppearanceTransition()}
//
//    override func dismissalTransitionWillBegin() {
//        presentingViewController.beginAppearanceTransition(true, animated: true)
//        guard let coordinator = presentingViewController.transitionCoordinator else {return}
//        coordinator.animate(alongsideTransition: {context in
//            self.blurView.alpha = 0.0
//        }, completion: nil)
//    }
//
//    override func dismissalTransitionDidEnd(_ completed: Bool) {if completed {blurView.removeFromSuperview()}}
//}
