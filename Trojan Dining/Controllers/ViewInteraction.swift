//
//  ViewInteraction.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

extension ViewController {
    //begin scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {cellIndexBeforeDrag = indexOfMajorCell()}
    //end scrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset

        let indexToSnapTo = self.indexOfMajorCell()

        // calculate conditions:
        let dataSourceCount = collectionView(collectionView, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trial and error
        let hasEnoughVelocityToSlideToTheNextCell = cellIndexBeforeDrag + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = cellIndexBeforeDrag - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexToSnapTo == cellIndexBeforeDrag
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {

            let snapToIndex = cellIndexBeforeDrag + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let offsetPerIndex = (collectionView.frame.width - ViewController.TOTAL_INSET - ViewController.PEAKING_AMOUNT_FOR_ITEMS)
            let toValue = offsetPerIndex * CGFloat(snapToIndex)

            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()

                self.segmentedControl.selectedSegmentTintColor = self.menu[snapToIndex].getColor()
                self.segmentedControl.layer.borderColor = self.segmentedControl.selectedSegmentTintColor?.cgColor
                self.updateBigText(snapToIndex)
            }, completion: nil)


        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexToSnapTo, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            UIView.animate(withDuration: 0.3) {
                self.segmentedControl.selectedSegmentTintColor = self.menu[indexToSnapTo].getColor()
                self.segmentedControl.layer.borderColor = self.segmentedControl.selectedSegmentTintColor?.cgColor
                self.updateBigText(indexToSnapTo)
            }
        }
    }

    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionView.frame.width - 2*ViewController.TOTAL_INSET
        let proportionalOffset = collectionView.contentOffset.x/itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
}
