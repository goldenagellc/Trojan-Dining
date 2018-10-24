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
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var HallLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Make sure background doesn't interfere with anything
        self.backgroundColor = UIColor.clear
        
        self.layer.masksToBounds = false
        // Enable shadows
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        // Enable rounded corners
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 16
        
        // Configure background view so it doesn't interfere with anything
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.layer.cornerRadius = 16
        self.selectedBackgroundView = backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override var frame: CGRect {
        get {return super.frame}
        set (newFrame) {super.frame = newFrame.insetBy(dx: 18, dy: 0)}
    }

}
