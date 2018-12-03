//
//  Card.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

public final class Meal: Filterer {
    public let name: String
    public let date: String
    public let halls: [String]
    public let foods: [[Food]]
    public private(set) lazy var isServed: Bool = {[unowned self] in return foods[0].count > 0}()// TODO only return true if hours haven't passed

    public private(set) var filteredFoods: [[Food]]

    init(name: String, date: String, halls: [String], foods: [[Food]]) {
        self.name = name
        self.date = date
        self.halls = halls
        self.foods = foods

        self.filteredFoods = foods
    }

    convenience init(fromHTMLMeal htmlMeal: MenuBuilder.HTMLMeal) {
        var halls: [String] = []
        var foods: [[Food]] = []

        for htmlHall in htmlMeal.halls {
            halls.append(htmlHall.name)
            foods.append([])
            for htmlSection in htmlHall.sections {
                for htmlFood in htmlSection.foods {
                    let food = Food(name: htmlFood.name, hall: htmlHall.name, section: htmlSection.name, allergens: htmlFood.allergens)
                    foods[foods.endIndex - 1].append(food)
        }}}

        self.init(name: htmlMeal.name_short, date: htmlMeal.date, halls: halls, foods: foods)
    }

//    public func generateView()

    public func apply(_ filter: Filter) {
        filteredFoods = []
        for section in foods {filteredFoods.append(section.filter {!$0.contains(unacceptableAllergens: filter.unacceptableAllergens)})}
    }

//    public func getHours()

//    public func getRelativeDate() //return "Today", "Tomorrow", etc
}



public final class Food {
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
        "Wheat / Gluten" : 11,
        "Food Not Analyzed for Allergens" : 12
    ]

//    public static let POSSIBLE_HALLS: [String: Int] = [
//        "USC Village Dining Hall" : 0,
//        "Parkside Restaurant & Grill" : 1,
//        "Everybody's Kitchen" : 2
//    ]

    public let name: String
    public let hall: String
    public let section: String
    public let allergens: [String]

    private lazy var standardizedAllergens: [Bool] = { [unowned self] in
        var standardized: [Bool] = [Bool](repeating: false, count: Food.POSSIBLE_ALLERGENS.count)
        for allergen in allergens {
            guard let allergenIndex: Int = Food.POSSIBLE_ALLERGENS[allergen] else {fatalError("Scraped an allergen not associated with a constant! :: " + allergen)}
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
            guard let allergenIndex: Int = Food.POSSIBLE_ALLERGENS[allergen] else {fatalError("Tried to filter out an allergen that doesn't exist!")}
            if standardizedAllergens[allergenIndex] {return true}
        }
        return false
    }

//    public func canBeFoundAt(diningHall hall: String) -> Bool {
//        return self.hall == hall
//    }
}
