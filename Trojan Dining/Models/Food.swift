//
//  Card.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

public final class Food: TableableData {
    public let CorrespondingView: TableableCell.Type = FoodCell.self

    public let name: String
    public let hall: String
    public let section: String
    public let attributes: [String]

    private lazy var standardizedAttributes: [Filter.AttributeStatus] = { [unowned self] in
        var standardized = [Filter.AttributeStatus](repeating: .absent, count: Food.POSSIBLE_ATTRIBUTES.count + 1)

        if attributes.count == 0 {standardized[standardized.count - 1] = .present}
        else {for attribute in attributes {
            guard let attributeIndex: Int = Food.POSSIBLE_ATTRIBUTES[attribute] else {fatalError("Scraped an attribute not associated with a constant! :: " + attribute)}
            standardized[attributeIndex] = .present

            //SPECIAL CASE
            if standardized[9] == .present {standardized[10] = .present}
        }}

        return standardized
    }()

    init(name: String, hall: String, section: String, attributes: [String]) {
        self.name = name
        self.hall = hall
        self.section = section
        self.attributes = attributes
    }
    
    public func hallShortName() -> String {
        switch hall {
        case "USC Village Dining Hall": return "Village"
        case "Parkside Restaurant & Grill": return "Parkside"
        case "Everybody's Kitchen": return "EVK"
        default: fatalError("\(hall) wasn't found on Firebase")
        }
    }
    
    public func hallLongName() -> String {
        switch hall.lowercased() {
        case "village": return "USC Village Dining Hall"
        case "parkside": return "Parkside Restaurant & Grill"
        case "evk": return "Everybody's Kitchen"
        default: fatalError("\(hall) is unknown")
        }
    }
    
    public static func hallHTMLEncoded(_ hall: String) -> String {
        switch hall.lowercased() {
        case "village": return "USC Village Dining Hall"
        case "parkside": return "Parkside Restaurant &amp; Grill"
        case "evk": return "Everybody&#039;s Kitchen"
        default: fatalError("\(hall) is unknown")
        }
    }

    public func hasAny(unacceptableAttributes attributes: [String]) -> Bool {
        for attribute in attributes {
            guard let attributeIndex: Int = Food.POSSIBLE_ATTRIBUTES[attribute] else {fatalError("Tried to filter out an attribute that doesn't exist! :: " + attribute)}
            if standardizedAttributes[attributeIndex] == .present {return true}
        }
        return false
    }

    public func hasAll(requiredAttributes attributes: [String]) -> Bool {
        for attribute in attributes {
            guard let attributeIndex: Int = Food.POSSIBLE_ATTRIBUTES[attribute] else {fatalError("Searched for an attribute that doesn't exist! :: " + attribute)}
            if standardizedAttributes[attributeIndex] != .present {return false}
        }
        return true
    }

    public func passes(_ filter: Filter) -> Bool {
        //Ensures ALL things that are supposed to be absent are absent
        //AND
        //Ensures AT LEAST ONE thing that is supposed to be present is present
        let validity = zip(standardizedAttributes, filter.specifications).reduce((false, false, false)) {(prev, curr) in
            //true only when filter contains .present
            let isAffirmativeSearchActive = prev.0 || (curr.1 == .present)
            //true only when at least one index contains .present in both standardizedAttributes and filter
            let isAffirmativeSearchSuccessful = prev.1 || (curr.0 == .present && curr.1 == .present)
            //true when any given index is .absent in the filter but .present in standardizedAttributes
            let hasUnacceptableAttributes = prev.2 || (curr.0 != .absent && curr.1 == .absent)
            return (isAffirmativeSearchActive, isAffirmativeSearchSuccessful, hasUnacceptableAttributes)
        }

        return (validity.0 == validity.1) && !validity.2
        
        //Ensures ALL conditions pass
//        var failures = zip(standardizedAttributes, filter.specifications).filter {$0 != $1 && $1 != Filter.AttributeStatus.inconsequential}
//        return failures.count == 0
    }
    
    public static let POSSIBLE_ATTRIBUTES: [String : Int] = [
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
}
