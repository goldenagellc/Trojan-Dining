//
//  CollectableData.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

public protocol CollectableData {
    var CorrespondingView: CollectableCell.Type { get }
    func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell
}

extension CollectableData {
    public func generateCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell {
        return CorrespondingView.insideOf(collectionView, at: indexPath).populatedBy(self, at: indexPath)
    }
}
