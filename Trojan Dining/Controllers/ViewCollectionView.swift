//
//  ViewCollectionView.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //cell spacing y
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return ViewController.SPACING_BETWEEN_ITEMS}
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 2*ViewController.TOTAL_INSET
//        segmentedControlWidth.constant = width
        return CGSize(width: width, height: collectionView.frame.height)
    }

    //number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return menu.count}

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return menu[indexPath.item].generateCellFor(collectionView, at: indexPath)
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? MealCell)?.hallToShow = selectedDiningHall
        (cell as? MealCell)?.parent = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: ViewController.TOTAL_INSET, bottom: 0.0, right: ViewController.TOTAL_INSET)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        MealCell.registerWith(collectionView)

        collectionView.allowsSelection = false
    }
}
