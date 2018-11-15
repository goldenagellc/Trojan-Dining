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

class Food {
    public static let POSSIBLE_ALLERGENS: [String: Int] = [
        "Dairy" : 0,
        "Eggs" : 1,
        "Fish" : 2,
        "Peanuts" : 3,
        "Pork" : 4,
        "Sesame" : 5,
        "Shellfish" : 6,
        "Soy" : 7,
        "Tree Nuts" : 8,
        "Vegan" : 9,
        "Vegetarian" : 10,
        "Wheat / Gluten" : 11
    ]

    public static let POSSIBLE_HALLS: [String: Int] = [
        "USC Village Dining Hall" : 0,
        "Parkside Restaurant & Grill" : 1,
        "Everybody's Kitchen" : 2
    ]

    public let name: String
    public let hall: String
    public let section: String
    public let allergens: [String]

    private lazy var standardizedAllergens: [Bool] = { [unowned self] in
        var standardized: [Bool] = [Bool](repeating: false, count: Food.POSSIBLE_ALLERGENS.count)
        for allergen in allergens {
            guard let allergenIndex: Int = Food.POSSIBLE_ALLERGENS[allergen] else {fatalError("Scraped allergen not possible?")}
            standardized[allergenIndex] = true
        }
        return standardized
    }()

    init(name: String, hall: String, section: String, allergens: [String]) {
        self.name = name
        self.hall = hall
        self.section = section
        self.allergens = allergens
    }

    public func contains(unacceptableAllergens allergens: [String]) -> Bool {
        for allergen in allergens {
            guard let allergenIndex: Int = Food.POSSIBLE_ALLERGENS[allergen] else {fatalError("Are you sure you're filtering correctly spelled allergens?")}
            if standardizedAllergens[allergenIndex] {return true}
        }
        return false
    }

    public func canBeFoundAt(diningHall hall: String) -> Bool {
        return self.hall == hall
    }
}


class Menu {
    let breakfast: [Food]
    let brunch: [Food]
    let lunch: [Food]
    let dinner: [Food]


    init(breakfast: [Food], brunch: [Food], lunch: [Food], dinner: [Food]) {
        self.breakfast = breakfast
        self.brunch = brunch
        self.lunch = lunch
        self.dinner = dinner
    }
}
