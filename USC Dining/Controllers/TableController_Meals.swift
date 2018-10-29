//
//  TableViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TableController_Meals: UITableViewController {
    
    //MARK: Properties
    private var menu = [MenuBuilder.Meal]()
    
    private var selectedCell: TableCell_Meal? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webScraper = WebScraper(self)
        webScraper.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableCell_Meal

        // Configure the cell...
        print(menu.count)
        if menu.count > 0 {
            let rawMealName: String = menu[indexPath.section].name
            let firstSpace = rawMealName.firstIndex(of: " ") ?? rawMealName.endIndex
            
            //let trimmedName: [String] = rawMealName.components(separatedBy: " ")
            let trimmedName: String = String(rawMealName[..<firstSpace])
            let secondSpace = rawMealName.index(firstSpace, offsetBy: 5)
            let date: String = String(rawMealName[secondSpace...])
            print(date)
            
            
            cell.mealView.windowTitle.text = trimmedName
            cell.mealView.windowSubtitle.text = date
        }
        
        if indexPath.section == 0 {
            cell.mealView.contentViewImage.image = UIImage(named: "Breakfast")
        }

//        cell.mealView.shadowView.layer.masksToBounds = true
        let radius = cell.mealView.shadowView.layer.cornerRadius
        let bounds = cell.mealView.shadowView.layer.bounds
        cell.mealView.shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        
        return cell
    }
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    public func updateMenu(with newMenu: [MenuBuilder.Meal]) {
        menu = newMenu
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
        
        if let toVC = segue.destination as? Controller_Meal {
            print("Did set transitionDelegate")
            toVC.transitioningDelegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCell = self.tableView(self.tableView, cellForRowAt: indexPath) as! TableCell_Meal
        
        print("Did try to perform segue")
        performSegue(withIdentifier: "ExpandMeal", sender: nil)
    }

}

extension TableController_Meals: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Did return animator")
        return AnimateMealExpand(originCell: self.selectedCell!)
    }
}
