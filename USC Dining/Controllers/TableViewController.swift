//
//  TableViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    private var menu = [MenuBuilder.Meal]()
    private var cellIsOpen = false

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

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

//        cell.mealView.shadowView.masksToBounds = true
        let radius = cell.mealView.shadowView.layer.cornerRadius
        let bounds = cell.mealView.shadowView.layer.bounds
        cell.mealView.shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        tableView.isUserInteractionEnabled = false
        cellIsOpen = true
        
        UIView.animate(withDuration: 0.2, animations: {
            selectedCell.mealView.windowToContentView.frame = selectedCell.mealView.windowToContentView.frame.insetBy(dx: -20, dy: -20)
            selectedCell.mealView.windowToContentView.layer.cornerRadius = 0
            selectedCell.mealView.disableShadow()
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return cellIsOpen
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Mathods
    public func updateMenu(with newMenu: [MenuBuilder.Meal]) {
        menu = newMenu
        DispatchQueue.main.async {self.tableView.reloadData()}
    }

}
