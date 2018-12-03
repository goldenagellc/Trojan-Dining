//
//  Filter.swift
//  USC Dining
//
//  Created by Hayden Shively on 12/3/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import Foundation

public protocol Filterer {
    func apply(_ filter: Filter)
}

public struct Filter {
    let unacceptableAllergens: [String]
}
