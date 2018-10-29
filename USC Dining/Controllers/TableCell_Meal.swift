//
//  TableViewCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TableCell_Meal: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var mealView: View_MealCondensed!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideBuiltInViews()
        configureTapped(color: UIColor.clear)
        
        mealView.attachContentTo(self.frame)// enlarge meal canvas to fill cell
        mealView.roundCorners()
        mealView.enableShadow()
        
        self.addSubview(mealView)
    }
    
    private func hideBuiltInViews() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
    }
    
    private func configureTapped(color: UIColor) {
        if self.selectedBackgroundView != nil {self.selectedBackgroundView!.backgroundColor = color}
        else {
            let tappedView = UIView()
            tappedView.backgroundColor = color
            self.selectedBackgroundView = tappedView
        }
    }
}
