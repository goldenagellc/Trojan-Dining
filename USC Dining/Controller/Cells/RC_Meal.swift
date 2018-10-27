//
//  RC_Meal.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/26/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class RC_Meal: RoundedCard {
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var mealName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundedView.layer.cornerRadius = RoundedCard.cornerRadius
        roundedView.clipsToBounds = true
    }
    
    // MARK: - Factory Method
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> RC_Meal {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "RC_Meal", for: indexPath) as! RC_Meal
    }
}
