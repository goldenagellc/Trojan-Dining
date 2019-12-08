//
//  MealCell.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

class MealCell: AUICollectionViewCell, CollectableCell {
    
    public static let REUSE_ID: String = "MealCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    public private(set) var data: Meal? = nil {
        didSet {backgroundColor = data?.getColor()}
    }
    public var hallToShow: Int = 0 {
        didSet {tableView.reloadData()}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8
        layer.masksToBounds = true
        engageTableView()
    }
    
    override public func populatedBy(_ data: CollectableData, at indexPath: IndexPath) -> AUICollectionViewCell {
        super.populatedBy(data, at: indexPath)
        self.data = (data as! Meal)
        return self
    }
}
    

extension MealCell: UITableViewDataSource, UITableViewDelegate {
    
    //header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 30}
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 40}
    //footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {return data?.filteredFoods[hallToShow].count ?? 0}
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return data?.filteredFoods[hallToShow][section].count ?? 0}

    //header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?.sections[hallToShow][section]
    }
    //header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {return}
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        headerView.backgroundView = blurEffectView
    }
    
    //cell generation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return data!.filteredFoods[hallToShow][indexPath.section][indexPath.row].generateCellFor(tableView, at: indexPath)
    }
    
    //MARK: - convenience functions
    func engageTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        FoodCell.registerWith(tableView)

        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
    }
}

