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
    
    override public func populatedBy(_ data: TableableData, at indexPath: IndexPath) -> AUITableViewCell {
        super.populatedBy(data, at: indexPath)
        label.text = (data as? Food)?.name
        return self
    }    
}
