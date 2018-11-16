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
    private var cardsToday = [Meal]()
    private var cardsTomorrow = [Meal]()
    private var cardsTheNextDay = [Meal]()
    
    // ----------
    // UIViewController
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scraperToday = WebScraper(forURL: AddressBuilder.url(for: .today)) {cards in
//            self.cardsToday = cards
//            DispatchQueue.main.async {self.tableView.reloadData()}
//        }
//        let scraperTomorrow = WebScraper(forURL: AddressBuilder.url(for: .tomorrow)) {cards in
//            self.cardsTomorrow = cards
//            DispatchQueue.main.async {self.tableView.reloadData()}
//        }
//        let scraperTheNextDay = WebScraper(forURL: AddressBuilder.url(for: .theNextDay)) {cards in
//            self.cardsTheNextDay = cards
//            DispatchQueue.main.async {self.tableView.reloadData()}
//        }
//        scraperToday.resume()
//        scraperTomorrow.resume()
//        scraperTheNextDay.resume()
    }
    
    // ----------
    // UITableViewDataSource
    // ----------
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sections: Int = 0
        if cardsToday.count > 0 {sections += 1}
        if cardsTomorrow.count > 0 {sections += 1}
        if cardsTheNextDay.count > 0 {sections += 1}
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Give each section a single row to hold the section's card
        switch section {
        case 0: return cardsToday.count
        case 1: return cardsTomorrow.count
        case 2: return cardsTheNextDay.count
        default: return 0
        }
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
        switch indexPath.section {
        case 0: cell.setData(toCard: cardsToday[indexPath.row])
        case 1: cell.setData(toCard: cardsTomorrow[indexPath.row])
        case 2: cell.setData(toCard: cardsTheNextDay[indexPath.row])
        default: break
        }
        cell.updateContent(isPressed: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // set header height
        return 30
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // set footer height
        return 0
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        // make table view background clear
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        headerView.layer.backgroundColor = UIColor.clear.cgColor
//        return headerView
//    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {return}
        switch section {
        case 0: view.textLabel?.text = "Today"
        case 1: view.textLabel?.text = "Tomorrow"
        case 2: view.textLabel?.text = "The Next Day"
        default: break
        }
        view.textLabel?.font = UIFont.boldSystemFont(ofSize: 33)
        view.textLabel?.textColor = UIColor.black
        view.textLabel?.frame = view.frame
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Today"
        case 1: return "Tomorrow"
        case 2: return "The Next Day"
        default: return nil
        }
    }
}




extension CardTableController: UIViewControllerTransitioningDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets called when user taps on a cell
        self.lastSelected = tableView.cellForRow(at: indexPath) as! CardTableCell
        performSegue(withIdentifier: "ExpandCard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: is call to super.prepare necessary?
        
        if let destination = segue.destination as? CardDetailController {
            destination.transitioningDelegate = self
            destination.modalPresentationCapturesStatusBarAppearance = true
            destination.modalPresentationStyle = .custom
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let cell = self.lastSelected!
        let cellFrame = cell.cardView.contentView.frame
        let cellRelativeToScreen = cell.cardView.contentView.superview!.convert(cellFrame, to: nil)

        let params = CardTransitioningDelegate.Params(fromCardFrame: cellRelativeToScreen,
                            /*fromCardFrameBeforeTransform: cardNoTransfrom,*/
                            fromCell: cell)


        return CardPresentationAnimation(params: params)
    }
}
