//
//  ViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/2/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit


class ViewController: UIViewController, Filterer {
    private static let SPACING_BETWEEN_ITEMS: CGFloat = 40
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: FilterView!

    private var mealViews = [CardView]()

    private var menu: [Meal] = []
    private var menuToday: [Meal] = []
    private var menuTomorrow: [Meal] = []
    private var menuTheNextDay: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        engageCollectionView()
        filterView.filterer = self

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
        collectionView.reloadData()
    }

    func apply(_ filter: Filter) {
        print(filter)
        for meal in menu {meal.apply(filter)}
        collectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*number of sections*/func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    /*number of cells   */func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return menu.count}

    /*cell spacing*/func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {return 0.0}

    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height - ViewController.SPACING_BETWEEN_ITEMS)
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardView
        cell.oneTimeSetup(withData: menu[indexPath.item])
        return cell
    }
    //cell display
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dx = ViewController.SPACING_BETWEEN_ITEMS - (view.frame.width - cell.frame.width)
        cell.frame = cell.frame.insetBy(dx: dx/2, dy: 0)
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardView.self, forCellWithReuseIdentifier: "CardView")
        collectionView.reloadData()
    }
}
