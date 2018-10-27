//
//  Meal.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/27/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class Meal: UIView {
    // CANVAS
    @IBOutlet var contentView: UIView!// constant size, no clipping, and clear
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var contentViewImage: UIImageView!// size = foundation size
    // note that contentViewImage should have clipToBounds = false and contentMode = .scaleAspectFill
    
    // WINDOW OPENING ONTO CANVAS
    @IBOutlet weak var windowToContentView: UIView!
    // DECALS ON THE WINDOW
    @IBOutlet weak var windowTitle: UILabel!
    @IBOutlet weak var windowSubtitle: UILabel!
    @IBOutlet weak var windowDescriptor: UILabel!
    
    // SHADOWS AROUND WINDOW
    @IBOutlet weak var shadowView: UIView!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        Bundle.main.loadNibNamed("Meal", owner: self, options: nil)
        addSubview(contentView)
        
        // TODO: - apparently the next 2 lines aren't the best way of doing things
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
