//
//  ViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/2/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    private static let SPACING_BETWEEN_ITEMS: CGFloat = 40
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var mealViews = [CardView]()

    private var menu: [Meal] = []
    private var menuToday: [Meal] = []
    private var menuTomorrow: [Meal] = []
    private var menuTheNextDay: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardView.self, forCellWithReuseIdentifier: "CardView")

        // Do any additional setup after loading the view.
        let scraperToday = WebScraper(forURL: AddressBuilder.url(for: .today)) {menu in
            DispatchQueue.main.async {self.menuToday = menu; self.reloadDataIfReady()}
        }
        let scraperTomorrow = WebScraper(forURL: AddressBuilder.url(for: .tomorrow)) {menu in
            DispatchQueue.main.async {self.menuTomorrow = menu; self.reloadDataIfReady()}
        }
        let scraperTheNextDay = WebScraper(forURL: AddressBuilder.url(for: .theNextDay)) {menu in
            DispatchQueue.main.async {self.menuTheNextDay = menu; self.reloadDataIfReady()}
        }
        scraperToday.resume()
        scraperTomorrow.resume()
        scraperTheNextDay.resume()
    }

    func reloadDataIfReady() {

        menu = (menuToday + menuTomorrow + menuTheNextDay).filter {$0.isServed}

        collectionView.reloadData()

    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(menu.count)
        return menu.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardView

        // Configure the cell
        cell.setData(mealData: menu[indexPath.item])
        cell.tableView.reloadData()
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let dx = ViewController.SPACING_BETWEEN_ITEMS - (view.frame.width - cell.frame.width)
        cell.frame = cell.frame.insetBy(dx: dx/2, dy: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height - 40)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20.0
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
