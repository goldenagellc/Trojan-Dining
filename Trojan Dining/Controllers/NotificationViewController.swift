//
//  NotificationViewController.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/9/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    internal var watchlist: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        engageTableView()
        
        TrojanDiningUser.shared.fetchUserWatchlist {
            self.watchlist += TrojanDiningUser.shared.watchlist
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    @IBAction func onPlusButtonTapped(_ sender: UIButton) {
//        TrojanDiningUser.shared.hasUpgraded { [weak self] hasUpgraded in
//            if hasUpgraded {
//                self?.watchlist.append("")
//                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//            }else {
//                self?.performSegue(withIdentifier: "UpgradeSegue", sender: self)
//            }
//        }
        
        if Market.shared.isProductPurchased(TrojanDiningProducts.MonthlyPro) {
            watchlist.append("")
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }else {
            performSegue(withIdentifier: "UpgradeSegue", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let watchlistFull = watchlist.filter({$0 != ""})
        TrojanDiningUser.shared.setUserWatchlist(watchlistFull)
    }
}

extension NotificationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        if let text = textField.text, text != "" {
            watchlist[indexPath.row] = text
        }else {
            watchlist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}


extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    //header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0}
    //footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return watchlist.count}
    
    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WatchlistCell.insideOf(tableView, at: indexPath) as! WatchlistCell
        cell.textField.text = watchlist[indexPath.row]
        return cell
    }
    
    //cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WatchlistCell else {return}
        cell.delegate = self
        cell.textField.isUserInteractionEnabled = true
        cell.textField.becomeFirstResponder()
    }
    //cell deselection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WatchlistCell else {return}
        cell.delegate = nil
        cell.textField.isUserInteractionEnabled = false
        cell.textField.resignFirstResponder()
    }
    
    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        WatchlistCell.registerWith(tableView)

        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = 30//UITableView.automaticDimension
    }
}

extension NotificationViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets.zero
        }
    }
}
