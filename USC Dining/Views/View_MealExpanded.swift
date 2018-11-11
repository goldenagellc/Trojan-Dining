//
//  View_MealExpanded.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/28/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class View_MealExpanded: UIView {
    
    // CANVAS
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var mealView: View_MealCondensed!
    
    
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
        Bundle.main.loadNibNamed("View_MealExpanded", owner: self, options: nil)
        addSubview(contentView)
        
        // TODO: - apparently the next 2 lines aren't the best way of doing things
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
