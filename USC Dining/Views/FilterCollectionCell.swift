//
//  FilterCollectionCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/3/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var pill: UIView!
    @IBOutlet weak var label: UILabel!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = UIColor.white
                pill.backgroundColor = UIColor.darkGray
            }else {
                label.textColor = UIColor.black
                pill.backgroundColor = UIColor.groupTableViewBackground
            }
        }
    }

    func roundCorners(toRadius radius: CGFloat? = nil) {
        contentView.layer.cornerRadius = radius ?? contentView.frame.height/2.0
        contentView.layer.masksToBounds = true
    }
}
