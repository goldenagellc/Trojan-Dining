//
//  FilterView.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/10/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class FilterView: UIView {

    // CANVAS
    @IBOutlet var contentView: FilterView!
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!

    // initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig()
    }

    // initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig()
    }

    // code to run regardless of initialization method
    private func homogeneousConfig() {
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        addSubview(contentView)

        // TODO: - apparently the next 2 lines aren't the best way of doing things
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @IBAction func onButtonClick(_ sender: Any) {
    }
}
