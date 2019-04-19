//
//  FilterCollectionCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/3/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var pill: UIView!
    @IBOutlet weak var label: UILabel!

    public var state: Filter.AttributeStatus = .inconsequential {
        didSet {
            switch state {
            case .present:
            label.textColor = UIColor.black
            pill.backgroundColor = UIColor.groupTableViewBackground
            case .inconsequential:
            label.textColor = UIColor.white
            pill.backgroundColor = UIColor.darkGray
            case .absent:
            label.textColor = UIColor.darkText
            pill.backgroundColor = UIColor.red
            }
        }
    }

    override var isSelected: Bool {didSet {}}

    public func roundCorners(toRadius radius: CGFloat? = nil) {
        contentView.layer.cornerRadius = radius ?? contentView.frame.height/2.0
        contentView.layer.masksToBounds = true
    }
}
