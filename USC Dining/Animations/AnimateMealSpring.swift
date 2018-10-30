//
//  AnimateMealSpring.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

func expandingSpringAnimator(params: Params) -> UIViewPropertyAnimator {
    let topOfCard = params.fromCardFrame.minY
    let distanceToBounce = abs(topOfCard)
    let extentToBounce = topOfCard < 0.0 ? params.fromCardFrame.height : UIScreen.main.bounds.height
    
    let dampFactorInterval: CGFloat = 0.3// TODO: constant
    let damping: CGFloat = 1.0 - dampFactorInterval*distanceToBounce/extentToBounce
    
    let minDuration: TimeInterval = 5.0//TODO: constant
    let maxDuration: TimeInterval = 9.0//TODO: constant
    let duration: TimeInterval = minDuration + (maxDuration - minDuration)*TimeInterval(max(0.0, distanceToBounce)/UIScreen.main.bounds.height)
    
    let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0.0, dy: 0.0))
    
    return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
}
