//
//  MenuBuilder.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit

public class MenuBuilder {
    
    public private(set) var menu: [HTMLMeal] = []
    
    private var shouldCheckWatchlist: Bool = false
    //                                     [Hall   : [Meal   : [Food  ]]]
    public private(set) var watchlistHits: [String : [String : [String]]]? = nil
    
    var currentMeal: HTMLMeal?
    var currentHall: HTMLHall?
    var currentSect: HTMLSection?
    var currentFood: HTMLFood?
    
    var readingMeal: Bool = false
    var readingHall: Bool = false
    var readingSect: Bool = false
    var readingFood: Bool = false
    
    public init(shouldCheckWatchlist: Bool = false) {
        self.shouldCheckWatchlist = shouldCheckWatchlist
        if self.shouldCheckWatchlist {watchlistHits = [:]}
    }
    
    public func processNewText(_ text: String) {
        // NOTE: this method relies on currentMeal, currentHall, currentSect, and currentFood being set to nil upon successful population
        
        // when readingMeal becomes true, use first encountered text as meal name
        if readingMeal {
            if mealIsNil() {initializeMeal(withName: text)}
            // when readingHall becomes true, use first encountered text as hall name
            else if readingHall {
                if hallIsNil() {initializeHall(withName: text)}
                // when readingSect becomes true, use first encountered text as sect name
                else if readingSect {
                    if sectIsNil() {initializeSect(withName: text)}
                    // when readingFood becomes true, use first encountered text as food name
                    else if readingFood {
                        if foodIsNil() {initializeFood(withName: text)}
                        // use other text to populate allergens
                        else {currentFood!.allergens.append(text)}
                    }
                }
            }
        }
    }
    
    public func processNewTag(_ tag: String) {
        switch tag {
        case HTMLMeal.startTag:
            saveMeal()
            resetMeal(); resetHall(); resetSect(); resetFood();
            
        case HTMLHall.startTag: if readingMeal {readingHall = true}
        case HTMLSection.startTag: if readingHall {readingSect = true}
        case HTMLFood.startTag: if readingSect {readingFood = true}
        case HTMLFood.endTag: if readingFood {saveFood(); resetFood();}
        case HTMLSection.endTag: if readingSect {saveSect(); resetSect();}
        case HTMLHall.endTag:
            if readingSect {saveSect(); resetSect();}// Solves issue that occurs when Section has no Foods
            if readingHall {saveHall(); resetHall();}
        default: break
        }
    }
    
    public func mealIsNil() -> Bool {return currentMeal == nil}
    public func hallIsNil() -> Bool {return currentHall == nil}
    public func sectIsNil() -> Bool {return currentSect == nil}
    public func foodIsNil() -> Bool {return currentFood == nil}
    
    public func initializeMeal(withName name: String) {currentMeal = HTMLMeal(name: name, halls: [])}
    public func initializeHall(withName name: String) {currentHall = HTMLHall(name: name, sections: [])}
    public func initializeSect(withName name: String) {currentSect = HTMLSection(name: name, foods: [])}
    public func initializeFood(withName name: String) {currentFood = HTMLFood(name: name, allergens: [])}
    
    public func saveMeal() {if let meal = currentMeal, meal.halls.count == 3 {menu.append(meal)}}
    private func saveHall() {if let hall = currentHall {currentMeal!.halls.append(hall)}}
    private func saveSect() {if let sect = currentSect {currentHall?.sections.append(sect)}}//TODO this broke when there were 4 meals (thanksgiving)
    private func saveFood() {
        if let food = currentFood {
            currentSect!.foods.append(food)
            if shouldCheckWatchlist {
                // TODO better way to load this than pulling from storage every single time
                TrojanDiningUser.shared.loadWatchlistLocally().forEach { watchedTerm in
                    if food.name.lowercased().contains(watchedTerm.lowercased()) {
                        var current = watchlistHits![currentHall!.decodedName] ?? [:]
                        current[currentMeal!.shortName] = (current[currentMeal!.name] ?? []) + [food.name]
                        watchlistHits![currentHall!.decodedName] = current
                    }
                }
            }
        }
    }
    
    private func resetMeal() {currentMeal = nil; readingMeal = true;}
    private func resetHall() {currentHall = nil; readingHall = false;}
    private func resetSect() {currentSect = nil; readingSect = false;}
    private func resetFood() {currentFood = nil; readingFood = false;}

}

extension MenuBuilder {
    
    public class HTMLMeal {
        // MARK: - Scraped Properties
        public let name: String
        public var halls: [HTMLHall]
        
        static let startTag: String = "<span class=\"fw-accordion-title-inner\">"
        
        init(name: String, halls: [HTMLHall]) {
            self.name = name
            self.halls = halls
        }
        
        // MARK: - Convenience methods using scraped properties
        public lazy var shortName: String = {
            return String(name.split(separator: " ")[0])
        }()
        
        public lazy var dateText: String = {
            let date = name.split(separator: "-")[1]
            return String(date.suffix(date.count - 1))
        }()
    }
    
    public struct HTMLHall {
        public let name: String
        public var sections: [HTMLSection]
        
        static let startTag: String = "<h3 class=\"menu-venue-title\">"
        static let endTag: String = "</div>"
        
        // MARK: - Convenience methods using scraped properties
        static let decodingOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        public lazy var decodedName: String = {
            guard let encoded = name.data(using: .utf8) else {
                return name
            }
            do {
                let decoded = try NSAttributedString(data: encoded, options: HTMLHall.decodingOptions, documentAttributes: nil)
                return decoded.string
            }catch {
                print("Failed to html-decode hall name: \(error)")
                return name
            }
        }()
    }
    
    public struct HTMLSection {
        public let name: String
        public var foods: [HTMLFood]
        
        static let startTag: String = "<h4>"
        static let endTag: String = "</ul>"
    }
    
    public struct HTMLFood {
        public let name: String
        public var allergens: [String]
        
        static let startTag: String = "<li>"
        static let endTag: String = "</li>"
    }
    
}
