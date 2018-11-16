//
//  TableViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardTableController: UITableViewController {

    private static let cellID = "CellID"

    // ----------
    // Properties
    // ----------
    public var lastSelected: CardTableCell? = nil

    private var data: Meal? = nil

//    override func awakeFromNib() {
//        title = "None"
//        tableView.register(CardTableCell.self, forCellReuseIdentifier: CardTableController.cellID)
//        print("woke from nib")
//    }
//
//    required init(coder: NSCoder) {
//        super.init(coder: coder)!
//
//        title = "None"
//        tableView.register(CardTableCell.self, forCellReuseIdentifier: CardTableController.cellID)
//        print("ran override init")
//    }

    convenience init(data: Meal, tableView: UITableView) {
//        self.init(style: UITableView.Style.grouped)
        self.init()
        self.data = data
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CardTableCell", bundle: nil), forCellReuseIdentifier: CardTableController.cellID)
    }
    
    // ----------
    // UIViewController
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "None"
    }
    
    // ----------
    // UITableViewDataSource
    // ----------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data?.halls.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.foods[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Whenever necessary, generate a new cell of type "TableViewCell"
        print("Cell")

        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableController.cellID, for: indexPath) as! CardTableCell
        cell.label.text = "hi"//meal?.foods[indexPath.section][indexPath.row].name
        return cell
    }
    
    // ----------
    // UITableViewDelegate
    // ----------
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // Before displaying a cell, populate its card with data
//        print("Cell display")
//        let cell = cell as! CardTableCell
//        cell.label.text = "hi"//meal?.foods[indexPath.section][indexPath.row].name
//        cell.layoutSubviews()
//
////        let cell = cell as! CardTableCell
////        switch indexPath.section {
////        case 0: cell.setData(toCard: cardsToday[indexPath.row])
////        case 1: cell.setData(toCard: cardsTomorrow[indexPath.row])
////        case 2: cell.setData(toCard: cardsTheNextDay[indexPath.row])
////        default: break
////        }
////        cell.updateContent(isPressed: false)
//    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // set header height
        return 30
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let view = view as? UITableViewHeaderFooterView else {return}
//        switch section {
//        case 0: view.textLabel?.text = "Today"
//        case 1: view.textLabel?.text = "Tomorrow"
//        case 2: view.textLabel?.text = "The Next Day"
//        default: break
//        }
//        view.textLabel?.font = UIFont.boldSystemFont(ofSize: 33)
//        view.textLabel?.textColor = UIColor.black
//        view.textLabel?.frame = view.frame
//    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?.halls[section]
    }
}




//extension CardTableController: UIViewControllerTransitioningDelegate {
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Gets called when user taps on a cell
//        self.lastSelected = tableView.cellForRow(at: indexPath) as! CardTableCell
//        performSegue(withIdentifier: "ExpandCard", sender: nil)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // TODO: is call to super.prepare necessary?
//        
//        if let destination = segue.destination as? CardDetailController {
//            destination.transitioningDelegate = self
//            destination.modalPresentationCapturesStatusBarAppearance = true
//            destination.modalPresentationStyle = .custom
//        }
//    }
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        let cell = self.lastSelected!
//        let cellFrame = cell.cardView.contentView.frame
//        let cellRelativeToScreen = cell.cardView.contentView.superview!.convert(cellFrame, to: nil)
//
//        let params = CardTransitioningDelegate.Params(fromCardFrame: cellRelativeToScreen,
//                            /*fromCardFrameBeforeTransform: cardNoTransfrom,*/
//                            fromCell: cell)
//
//
//        return CardPresentationAnimation(params: params)
//    }
//}
