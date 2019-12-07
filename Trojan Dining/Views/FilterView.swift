//
//  FilterView.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/10/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

class FilterView: UIView {

    private static let CELL_ID: String = "FilterCollectionCell"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    public var dataDuct: DataDuct? = nil
    private let attributes: [String] = Array(Food.POSSIBLE_ATTRIBUTES.keys)
    public var filter: Filter = Filter(unacceptable: [], required: [])

    /*programmatic init     */override init(frame: CGRect) {              super.init(frame: frame);       combinedInit()}
    /*interface builder init*/required init?(coder aDecoder: NSCoder) {   super.init(coder: aDecoder);    combinedInit()}
    private func combinedInit() {
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        engageCollectionView()
    }
}


extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*number of sections*/func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    /*number of cells   */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return attributes.count}

    /*cell spacing*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 20.0}

    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelLength = attributes[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold)
        ])
        return CGSize(width: labelLength.width + 30, height: collectionView.frame.height)
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterView.CELL_ID, for: indexPath)
        return cell
    }
    //cell display
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = cell as? FilterCollectionCell,
            let attributeIndex = Food.POSSIBLE_ATTRIBUTES[attributes[indexPath.item]]
            else {return}

        cell.label.text = attributes[indexPath.item]
        cell.roundCorners()
        cell.state = filter.specifications[attributeIndex]
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let attributeIndex = Food.POSSIBLE_ATTRIBUTES[attributes[indexPath.item]],
            let dataDuct = dataDuct
            else {return}

        filter.cycleStatus(at: attributeIndex)
        dataDuct.apply(filter)
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard
            let attributeIndex = Food.POSSIBLE_ATTRIBUTES[attributes[indexPath.item]],
            let dataDuct = dataDuct
            else {return}

        filter.cycleStatus(at: attributeIndex)
        dataDuct.apply(filter)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        filter.load()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: FilterView.CELL_ID, bundle: nil), forCellWithReuseIdentifier: FilterView.CELL_ID)
        collectionView.reloadData()

        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
    }
}
