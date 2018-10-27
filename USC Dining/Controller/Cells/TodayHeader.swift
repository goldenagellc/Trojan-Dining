//
//  TodayHeader.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/26/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TodayHeader: UICollectionReusableView {
    
    internal static let viewHeight: CGFloat = 80

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Factory Method
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, ofKind kind: String, atIndexPath indexPath: IndexPath) -> TodayHeader {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodayHeader", for: indexPath) as! TodayHeader
    }
}
