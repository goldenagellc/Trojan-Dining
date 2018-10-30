//
//  TableViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardTableController: UITableViewController {

    // ----------
    // Properties
    // ----------
    public var lastSelected: CardTableCell? = nil
    private var cards = [Card]()
    
    public func updateCards(with newCards: [Card]) {
        cards = newCards
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    // ----------
    // UIViewController
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webScraper = WebScraper(self)
        webScraper.resume()
    }
    
    // ----------
    // UITableViewDataSource
    // ----------
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
    
    // ----------
    // UITableViewDelegate
    // ----------
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Before displaying a cell, populate its card with data
        let cell = cell as! CardTableCell
        cell.setData(toCard: cards[indexPath.section])
        cell.updateContent(isPressed: false)
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
}




extension CardTableController: UIViewControllerTransitioningDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets called when user taps on a cell
        self.lastSelected = tableView.cellForRow(at: indexPath) as! CardTableCell
        
        print("Requesting that segue starts")
        performSegue(withIdentifier: "ExpandMeal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: is call to super.prepare necessary?
        
        if let toVC = segue.destination as? CardDetailController {
            print("Segue request received. Preparing to begin")
            toVC.transitioningDelegate = self
            toVC.modalPresentationCapturesStatusBarAppearance = true
            toVC.modalPresentationStyle = .custom
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let cell = self.lastSelected!
        let cellFrame = cell.layer.presentation()!.frame
        let cellRelativeToScreen = cell.superview!.convert(cellFrame, to: nil)
        let cardNoTransfrom = {() -> CGRect in//for dismissing
            let center = cell.center; let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width/2.0,
                y: center.y - size.height/2.0,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let params = Params(fromCardFrame: cellRelativeToScreen,
                            fromCardFrameBeforeTransform: cardNoTransfrom,
                            fromCell: cell)
        
        
        print("Segue received definition of custom animation")
        
        return AnimateMealExpand(params: params)
    }
}
