//
//  CardView.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    static let DEFAULT_CORNER_RADIUS: CGFloat = 16.0
    static let DEFAULT_SHADOW_OPACITY: Float = 0.15
    static let DEFAULT_SHADOW_WIDTH: CGFloat = 8.0
    
    // CANVAS
    @IBOutlet var contentView: UIView!
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_subtitle: UILabel!
    @IBOutlet weak var label_description: UILabel!
    // SHADOWS
    @IBOutlet weak var shadowView: UIView!
    
    
    // initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig()
    }
    
    // initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig()
    }
    
    // code to run regardless of initialization method
    private func homogeneousConfig() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        
        // TODO: - apparently the next 2 lines aren't the best way of doing things
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        image.contentMode = .center
    }
    
    // MARK: - convenience functions
    
    func roundCorners(toRadius radius: CGFloat = CardView.DEFAULT_CORNER_RADIUS) {
        contentView.layer.cornerRadius = radius
        shadowView.layer.cornerRadius = radius
    }
    
    func enableShadow(withOpacity opacity: Float = CardView.DEFAULT_SHADOW_OPACITY, withWidth radius: CGFloat = CardView.DEFAULT_SHADOW_WIDTH) {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowRadius = radius
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowView.isHidden = false
        
        // prepare shadows for scrolling, TODO: must this be called more frequently?
        let bounds = shadowView.layer.bounds
        let radius = shadowView.layer.cornerRadius
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }
    
    func disableShadow() {
        shadowView.isHidden = true
    }
    
    func attachContentTo(_ frame: CGRect) {
        contentView.frame = frame
    }
}
