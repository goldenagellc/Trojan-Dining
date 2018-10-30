//
//  TableViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TableController_Meals: UITableViewController {

    private var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webScraper = WebScraper(self)
        webScraper.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Give each card its own section rather than just a row
        // This allows each one to have a unique header if necessary
        return cards.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Give each section a single row to hold the section's card
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Whenever necessary, generate a new cell of type "TableViewCell"
        return tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Before displaying a cell, populate it with meal data
        let cell = cell as! TableCell_Meal
        let card = cards[indexPath.section]
        
        cell.mealView.windowTitle.text = card.title
        cell.mealView.windowSubtitle.text = card.subtitle
        cell.mealView.windowDescriptor.text = card.description
//        cell.mealView.contentViewImage.image = card.image
        
        // for debugging purposes, leave last image blank to see shadows better
        if indexPath.section < 2 {cell.mealView.contentViewImage.image = card.image}
    }
    

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        // set header height
//        return 9
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        // set footer height
//        return 9
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        // make table view background clear
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    

    public func updateCards(with newCards: [Card]) {
        cards = newCards
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
}




extension TableController_Meals: UIViewControllerTransitioningDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets called when user taps on a cell
        print("Requesting that segue starts")
        performSegue(withIdentifier: "ExpandMeal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: is call to super.prepare necessary?
        
        if let toVC = segue.destination as? Controller_Meal {
            print("Segue request received. Preparing to begin")
            toVC.transitioningDelegate = self
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Segue received definition of custom animation")
        return AnimateMealExpand()
    }
}
