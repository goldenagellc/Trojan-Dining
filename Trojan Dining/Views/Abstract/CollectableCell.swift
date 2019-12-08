//
//  CollectableCell.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

public protocol CollectableCell {
    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ collectionView: UICollectionView)
    static func insideOf(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell
}
extension CollectableCell {
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ collectionView: UICollectionView) {collectionView.register(getUINib(), forCellWithReuseIdentifier: REUSE_ID)}
    public static func insideOf(_ collectionView: UICollectionView, at indexPath: IndexPath) -> AUICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_ID, for: indexPath) as! AUICollectionViewCell
    }
}

public class AUICollectionViewCell: UICollectionViewCell {
    public var indexPath: IndexPath?
    public func populatedBy(_ data: CollectableData, at indexPath: IndexPath) -> AUICollectionViewCell {
        self.indexPath = indexPath
        return self
    }
}
