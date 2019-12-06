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
                label.textColor = .label//.darkText
                pill.backgroundColor = .systemGray2
            case .inconsequential:
                label.textColor = .label
                pill.backgroundColor = .systemGray5
            case .absent:
                label.textColor = .label//.darkText
                pill.backgroundColor = .red
            }
        }
    }

    override var isSelected: Bool {didSet {}}

    public func roundCorners(toRadius radius: CGFloat? = nil) {
        contentView.layer.cornerRadius = radius ?? contentView.frame.height/2.0
        contentView.layer.masksToBounds = true
    }
}
