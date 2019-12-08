//
//  TableableData.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

public protocol TableableData {
    var CorrespondingView: TableableCell.Type { get }
    func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell
}

extension TableableData {
    public func generateCellFor(_ tableView: UITableView, at indexPath: IndexPath) -> AUITableViewCell {
        return CorrespondingView.insideOf(tableView, at: indexPath).populatedBy(self, at: indexPath)
    }
}
