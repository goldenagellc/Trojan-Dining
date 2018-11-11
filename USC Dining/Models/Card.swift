//
//  Card.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

struct Card {
    let title: String
    let subtitle: String
    let foods: [Food]
}

struct Food {
    let name: String
    let location: String
    let section: String
    let allergens: [String]
}
