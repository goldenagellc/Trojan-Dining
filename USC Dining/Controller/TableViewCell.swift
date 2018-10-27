//
//  TableViewCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var mealView: Meal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // get all the built-in views out the way
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
        
        
        // enlarge meal canvas to fill cell
        self.mealView.contentView.frame = self.frame
        // add rounded corners
        self.mealView.windowToContentView.layer.cornerRadius = 16
        self.mealView.shadowView.layer.cornerRadius = 16
        // add shadow
        self.mealView.shadowView.layer.masksToBounds = false
        self.mealView.shadowView.layer.shadowOpacity = 0.15
        self.mealView.shadowView.layer.shadowRadius = 8
        self.mealView.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.mealView.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        // attach meal view to cell
        self.addSubview(mealView)
        
        
        // make sure the cell doesn't change colors when tapped
        let selectedColor = UIView()
        selectedColor.backgroundColor = UIColor.clear
        self.selectedBackgroundView = selectedColor
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // configure the view for the selected state
    }
}
