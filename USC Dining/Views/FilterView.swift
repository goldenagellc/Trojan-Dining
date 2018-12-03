//
//  FilterView.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/10/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class FilterView: UIView {

    private static let CELL_ID: String = "FilterCollectionCell"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    public var filterer: Filterer? = nil
    private let allergens: [String] = Array(Food.POSSIBLE_ALLERGENS.keys)
    public private(set) var unselectedAllergens: Set<String> = Set<String>()

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
    /*number of cells   */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return allergens.count}

    /*cell spacing*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 20.0}

    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelLength = allergens[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold)
        ])
        return CGSize(width: labelLength.width + 30, height: collectionView.frame.height)
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterView.CELL_ID, for: indexPath) as! FilterCollectionCell
        cell.label.text = allergens[indexPath.item]
        cell.roundCorners()
        return cell
    }
    //cell display
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unselectedAllergens.remove(allergens[indexPath.item])
        guard let filterer = filterer else {return}
        filterer.apply(Filter(unacceptableAllergens: Array(unselectedAllergens)))
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        unselectedAllergens.insert(allergens[indexPath.item])
        guard let filterer = filterer else {return}
        filterer.apply(Filter(unacceptableAllergens: Array(unselectedAllergens)))
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: FilterView.CELL_ID, bundle: nil), forCellWithReuseIdentifier: FilterView.CELL_ID)
        collectionView.reloadData()

        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true

        for i in 0 ..< allergens.count {
            collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: false, scrollPosition: [])
        }
    }
}
