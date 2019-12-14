//
//  ViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/2/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit


class ViewController: UIViewController, DataDuct {
    static let SPACING_BETWEEN_ITEMS: CGFloat = 16
    static let PEAKING_AMOUNT_FOR_ITEMS: CGFloat = 16
    static let TOTAL_INSET: CGFloat = ViewController.SPACING_BETWEEN_ITEMS + ViewController.PEAKING_AMOUNT_FOR_ITEMS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlWidth: NSLayoutConstraint!
    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var bigTitleText: UILabel!
    
    var SCROLL_THRESHOLD: CGFloat = 50
    var cellIndexBeforeDrag: Int = 0
    var selectedDiningHall: Int = 0

    var menu: [Meal] = []
    var menuToday: [Meal] = []
    var menuTomorrow: [Meal] = []
    var menuTheNextDay: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        engageCollectionView()
        SCROLL_THRESHOLD = view.frame.width/8.0

        titleLabelLeading.constant = ViewController.TOTAL_INSET

        segmentedControl.layer.borderColor = segmentedControl.tintColor.cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.isUserInteractionEnabled = false

        filterView.dataDuct = self

        let scraperToday = WebScraper(forURL: URLBuilder.url(for: .today)) {menu in
            DispatchQueue.main.async {self.menuToday = menu; self.reloadData()}
        }
        let scraperTomorrow = WebScraper(forURL: URLBuilder.url(for: .tomorrow)) {menu in
            DispatchQueue.main.async {self.menuTomorrow = menu; self.reloadData()}
        }
        let scraperTheNextDay = WebScraper(forURL: URLBuilder.url(for: .theNextDay)) {menu in
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
            segmentedControl.selectedSegmentTintColor = menu.first?.getColor()
            segmentedControl.layer.borderColor = segmentedControl.selectedSegmentTintColor?.cgColor
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)

            segmentedControl.isUserInteractionEnabled = true
            
            updateBigText(cellIndexBeforeDrag)
            apply(filterView.filter)
        }
    }

    func apply(_ filter: Filter) {
        filter.save()
        for meal in menu {meal.apply(filter)}
        collectionView.reloadData()
    }

    @IBAction func onSegmentedControlClick(_ sender: Any) {
        selectedDiningHall = segmentedControl.selectedSegmentIndex
        collectionView.reloadData()
    }
    
    func updateBigText(_ menuIndex: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let date = dateFormatter.date(from: menu[menuIndex].date)
        dateFormatter.dateFormat = "M/d"
        bigTitleText.text = menu[menuIndex].name + ", " + dateFormatter.string(from: date!)
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let toVC = segue.destination
        
        switch segue.identifier {
        case "FoodDetailSegue":
            (toVC as! FoodDetailController).food = sender as? Food
        default: break
        }
    }
}


