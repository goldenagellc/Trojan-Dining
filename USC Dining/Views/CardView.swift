//
//  CardView.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardView: UICollectionViewCell {
    
    static let CELL_ID: String = "CardTableCell"
    static let CORNER_RADIUS: CGFloat = 16.0
    static let BORDER_WIDTH: CGFloat = 4.0
    

    //scene on canvas
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_subtitle: UILabel!

    private var data: Meal = Meal(name: "", date: "", halls: [], foods: [])

    //initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig(frame: frame)
    }
    //initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig(frame: frame)
    }

    convenience init(frame: CGRect, mealData data: Meal) {
        self.init(frame: frame)
        self.data = data

        label_title.text = data.name
//        label_subtitle.text = data.hours()
        label_subtitle.text = data.date
        
        prepareTableView()
    }

    public func setData(mealData data: Meal) {
        self.data = data

        label_title.text = data.name
//        label_subtitle.text = data.hours()
        label_subtitle.text = data.date

        prepareTableView()
    }
    
    //run regardless of initialization method
    private func homogeneousConfig(frame: CGRect) {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)

        roundCorners()
//        addBorder()
    }
    

    func roundCorners(toRadius radius: CGFloat = CardView.CORNER_RADIUS) {
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true

        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = radius
        tableView.layer.masksToBounds = true
    }

    func addBorder(withWidth width: CGFloat = CardView.BORDER_WIDTH) {
        contentView.layer.borderColor = contentView.backgroundColor?.cgColor
        contentView.layer.borderWidth = width
        contentView.layer.masksToBounds = true
    }
}
    

extension CardView: UITableViewDataSource, UITableViewDelegate {
    
    /*header height*/func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 30}
    /*cell height  */func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 40}
    /*footer height*/func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0}
    
    /*number of sections*/func numberOfSections(in tableView: UITableView) -> Int {return data.halls.count}
    /*number of rows    */func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return data.foods[section].count}

    //header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data.halls[section]
    }
    //header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {return}
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.groupTableViewBackground//contentView.backgroundColor
        headerView.backgroundView = backgroundView
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardView.CELL_ID, for: indexPath) as! CardTableCell
        cell.label.text = data.foods[indexPath.section][indexPath.row].name
        return cell
    }
    
    //MARK: - convenience functions
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardTableCell", bundle: nil), forCellReuseIdentifier: CardView.CELL_ID)
    }
}
