//
//  TableableCell.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

public protocol TableableCell {
    static var REUSE_ID: String { get }

    static func getUINib() -> UINib
    static func registerWith(_ tableView: UITableView)
    static func insideOf(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell
}
extension TableableCell {
    public static func getUINib() -> UINib {return UINib(nibName: REUSE_ID, bundle: nil)}
    public static func registerWith(_ tableView: UITableView) {tableView.register(getUINib(), forCellReuseIdentifier: REUSE_ID)}
    public static func insideOf(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: REUSE_ID, for: indexPath) as! AUITableViewCell
    }
}

public class AUITableViewCell: UITableViewCell {
    public var indexPath: IndexPath?
    public func populatedBy(_ data: TableableData, at indexPath: IndexPath) -> AUITableViewCell {
        self.indexPath = indexPath
        return self
    }
}
