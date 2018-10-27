//
//  RoundedCard.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/26/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit
import CoreMotion

class RoundedCard: UICollectionViewCell {
    
    internal static let cellHeight: CGFloat = 470.0
    internal static let cornerRadius: CGFloat = 16.0
    
    private static let innerMargin: CGFloat = 20.0
    private static let shadowOpacity: Float = 0.15
    
    // Core Motion Manager
    private let motionManager = CMMotionManager()
    
    // Long Press Gesture Recognizer
//    private var longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
    
    private var isPressed: Bool = false
    
    // Shadow View
    private weak var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        configureGestureRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: - Shadow
    private func configureShadow() {
        // Basic Config
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: bounds.insetBy(dx: RoundedCard.innerMargin, dy: RoundedCard.innerMargin))
        
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Dynamic Shadow
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: {(motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch*10
                    let roll = motion.attitude.roll*10
                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                }
            })
        }
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = RoundedCard.cornerRadius/2
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = RoundedCard.shadowOpacity
            
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: RoundedCard.cornerRadius)
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    // MARK: - Gesture Recognizer
    
//    private func configureGestureRecognizer() {
//        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
//        longPressGestureRecognizer?.minimumPressDuration = 0.1
//        addGestureRecognizer(longPressGestureRecognizer!)
//    }
//    
//    internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
//        switch gestureRecognizer.state {
//        case UIGestureRecognizer.State.began:
//            handleLongPressBegan()
//        case UIGestureRecognizer.State.ended, UIGestureRecognizer.State.cancelled:
//            handleLongPressEnded()
//        default:
//            break
//        }
//    }
//    
//    private func handleLongPressBegan() {
//        guard !isPressed else {return}
//        isPressed = true
//        
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
//            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }, completion: nil)
//    }
//    
//    private func handleLongPressEnded() {
//        guard isPressed else {return}
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
//            self.transform = CGAffineTransform.identity
//        }, completion: {(finished) in
//            self.isPressed = false
//        })
//    }
}
