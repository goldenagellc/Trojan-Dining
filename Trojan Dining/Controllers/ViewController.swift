//
//  ViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/2/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit


class ViewController: UIViewController, DataDuct {
    private static let SPACING_BETWEEN_ITEMS: CGFloat = 16
    private static let PEAKING_AMOUNT_FOR_ITEMS: CGFloat = 16
    private static let TOTAL_INSET: CGFloat = ViewController.SPACING_BETWEEN_ITEMS + ViewController.PEAKING_AMOUNT_FOR_ITEMS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlWidth: NSLayoutConstraint!
    @IBOutlet weak var filterView: FilterView!

    private var SCROLL_THRESHOLD: CGFloat = 50
    private var cellIndexBeforeDrag: Int = 0
    private var selectedDiningHall: Int = 0

    private var menu: [Meal] = [Meal(name: "Menu", date: "Today", halls: [], foods: [[Food(name: "", hall: "", section: "", attributes: [])]])]
    private var menuToday: [Meal] = []
    private var menuTomorrow: [Meal] = []
    private var menuTheNextDay: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        engageCollectionView()
        SCROLL_THRESHOLD = view.frame.width/8.0

        titleLabelLeading.constant = ViewController.TOTAL_INSET

        segmentedControl.layer.cornerRadius = 16
        segmentedControl.layer.borderColor = segmentedControl.tintColor.cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.masksToBounds = true

        filterView.dataDuct = self

        let scraperToday = WebScraper(forURL: AddressBuilder.url(for: .today)) {menu in
            DispatchQueue.main.async {self.menuToday = menu; self.reloadData()}
        }
        let scraperTomorrow = WebScraper(forURL: AddressBuilder.url(for: .tomorrow)) {menu in
            DispatchQueue.main.async {self.menuTomorrow = menu; self.reloadData()}
        }
        let scraperTheNextDay = WebScraper(forURL: AddressBuilder.url(for: .theNextDay)) {menu in
            DispatchQueue.main.async {self.menuTheNextDay = menu; self.reloadData()}
        }
        scraperToday.resume()
        scraperTomorrow.resume()
        scraperTheNextDay.resume()
    }

    func reloadData() {
        menu = (menuToday + menuTomorrow + menuTheNextDay).filter {$0.isServed}

        let countOfMealsServedToday = menuToday.filter({$0.isServed}).count
        if (countOfMealsServedToday > 0) || ((countOfMealsServedToday == 0) && menuTomorrow.count > 0) {
            segmentedControl.tintColor = menu[0].getColor()
            segmentedControl.layer.borderColor = segmentedControl.tintColor.cgColor

            collectionView.performBatchUpdates({collectionView.reloadSections(IndexSet(arrayLiteral: 0))}, completion: nil)
        }
    }

    func apply(_ filter: Filter) {
        for meal in menu {meal.apply(filter)}
        collectionView.reloadData()
    }

    @IBAction func onSegmentedControlClick(_ sender: Any) {
        selectedDiningHall = segmentedControl.selectedSegmentIndex
        collectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*number of sections*/func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    /*number of cells   */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return menu.count}

    /*cell spacing*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return ViewController.SPACING_BETWEEN_ITEMS}

    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 2*ViewController.TOTAL_INSET
        segmentedControlWidth.constant = width
        return CGSize(width: width, height: collectionView.frame.height)
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardView
        cell.oneTimeSetup(withData: menu[indexPath.item], butOnlyShow: selectedDiningHall)
        return cell
    }
    //cell display
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? CardView else {return}
//    }

    //edge insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: ViewController.TOTAL_INSET, bottom: 0.0, right: ViewController.TOTAL_INSET)
    }

    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionView.frame.width - 2*ViewController.TOTAL_INSET
        let proportionalOffset = collectionView.contentOffset.x/itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    //begin scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {cellIndexBeforeDrag = indexOfMajorCell()}
    //end scrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset

        let indexToSnapTo = self.indexOfMajorCell()

        // calculate conditions:
        let dataSourceCount = collectionView(collectionView, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = cellIndexBeforeDrag + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = cellIndexBeforeDrag - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexToSnapTo == cellIndexBeforeDrag
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {

            let snapToIndex = cellIndexBeforeDrag + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let offsetPerIndex = (collectionView.frame.width - ViewController.TOTAL_INSET - ViewController.PEAKING_AMOUNT_FOR_ITEMS)
            let toValue = offsetPerIndex * CGFloat(snapToIndex)
//            toValue += -1*ViewController.PEAKING_AMOUNT_FOR_ITEMS

            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()

                self.segmentedControl.tintColor = self.menu[snapToIndex].getColor()
                self.segmentedControl.layer.borderColor = self.segmentedControl.tintColor.cgColor
            }, completion: nil)


        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexToSnapTo, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            UIView.animate(withDuration: 0.3) {
                self.segmentedControl.tintColor = self.menu[indexToSnapTo].getColor()
                self.segmentedControl.layer.borderColor = self.segmentedControl.tintColor.cgColor
            }
        }
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardView.self, forCellWithReuseIdentifier: "CardView")

        collectionView.allowsSelection = false

        collectionView.reloadData()
    }
}
