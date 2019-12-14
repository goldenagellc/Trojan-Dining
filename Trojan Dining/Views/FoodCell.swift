//
//  TableViewCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

class FoodCell: AUITableViewCell, TableableCell {
    
    public static var REUSE_ID: String = "FoodCell"
    
    @IBOutlet weak var label: UILabel!
    
    public var data: Food? = nil {
        didSet {label.text = data?.name}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override public func populatedBy(_ data: TableableData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        self.data = (data as! Food)
        return self
    }    
}
