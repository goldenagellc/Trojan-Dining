//
//  CardView.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    static let CORNER_RADIUS: CGFloat = 16.0
    
    // CANVAS
    @IBOutlet var contentView: UIView!
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_subtitle: UILabel!

    private var data: Meal = Meal(name: "", date: "", halls: [], foods: [])

    
    // initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig(frame: frame)
    }
    
    // initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig(frame: frame)
    }

    convenience init(frame: CGRect, mealData data: Meal) {
        self.init(frame: frame)
        self.data = data

        label_title.text = data.name
//        label_subtitle.text = data.hours()
        label_subtitle.text = data.date
    }
    
    // code to run regardless of initialization method
    private func homogeneousConfig(frame: CGRect) {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)

        attachContentTo(frame)
        roundCorners()
    }
    
    // MARK: - convenience functions
    
    func attachContentTo(_ frame: CGRect) {
        contentView.frame = frame
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func roundCorners(toRadius radius: CGFloat = CardView.CORNER_RADIUS) {
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
    }
}
