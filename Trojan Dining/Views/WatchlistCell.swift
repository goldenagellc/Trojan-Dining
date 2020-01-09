//
//  WatchlistCell.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/9/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import UIKit

class WatchlistCell: AUITableViewCell, TableableCell {
    
    static var REUSE_ID: String = "WatchlistCell"
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
