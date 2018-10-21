import UIKit

import Foundation

//var menu = Scrape(address: "https://hospitality.usc.edu/residential-dining-menus/")//?menu_date=October+19%2C+2018")
//print(menu)

struct Food {
    let name: String
    var allergens: [String]
    
    static let startTag: String = "<li>"
    static let endTag: String = "</li>"
}

struct Section {
    let name: String
    var foods: [Food]
    
    static let startTag: String = "<h4>"
    static let endTag: String = "</ul>"
}

struct DiningHall {
    let name: String
    var sections: [Section]
    
    static let startTag: String = "<h3 class=\"menu-venue-title\">"
    static let endTag: String = "</div>"
}

struct Meal {
    let name: String
    var locations: [DiningHall]
    
    static let startTag: String = "<span class=\"fw-accordion-title-inner\">"
}



// define constants for filtering
//let BODY_BEGIN: String = "<body>"
//let MENU_BEGIN: String = "<div class=\"fw-accordion-custom meal-section\">"

// set address to scrape
var address: String = "https://hospitality.usc.edu/residential-dining-menus/?menu_date=October+21%2C+2018"
let url = URL(string: address)!


let task = URLSession.shared.dataTask(with: url) { data, response, error in
    // error handling part 1
    if let error = error {return}
    // error handling part 2
    guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
        return
    }
    // success
    if let mimeType = httpResponse.mimeType, mimeType == "text/html",
        let data = data,
        let html = String(data: data, encoding: .utf8) {
        
        var meals: [Meal] = []
        
        // for finding html tags
        var readingTag: Bool = false
        var currentTag: String = ""
        var currentNonTag: String = ""
        // for finding menu headers
        var readingMeal: Bool = false
        var readingHall: Bool = false
        var readingSect: Bool = false
        var readingFood: Bool = false
        
        var currentMeal: Meal?
        var currentHall: DiningHall?
        var currentSect: Section?
        var currentFood: Food?
        
        
        for char in html {
            // for finding html tags
            if char == "<" {
//                print(currentTag)
//                print(currentNonTag)
//                print("")
                readingTag = true;
                currentTag = ""
                
                if currentNonTag.count > 0 {
                    if readingMeal {
                        if currentMeal == nil {currentMeal = Meal(name: currentNonTag, locations: [])}
                        
                        else if readingHall {
                            if currentHall == nil {currentHall = DiningHall(name: currentNonTag, sections: [])}
                            
                            else if readingSect {
                                if currentSect == nil {currentSect = Section(name: currentNonTag, foods: [])}
                                
                                else if readingFood {
                                    if currentFood == nil {currentFood = Food(name: currentNonTag, allergens: [])}
                                    else {currentFood!.allergens.append(currentNonTag)}
                                }
                            }
                        }
                    }
                }
                
                if currentNonTag == "Legend" {
                    // same meal setting code as down below, but this runs at the very end to take care of dinner
                    // necessary since start tag won't be hit again
                    if let meal = currentMeal {
                        //                        print(meal.locations.count)
                        if meal.locations.count == 3 {
                            meals.append(meal)
                            currentMeal = nil
                        }
                    }
                }
                
                currentNonTag = ""
            }
            
            if readingTag {currentTag.append(char)}
            else {currentNonTag.append(char)}
            
            if char == ">" {
                readingTag = false
                
                switch currentTag {
                case Meal.startTag:
                    readingMeal = true
                    
                    if let meal = currentMeal {
//                        print(meal.locations.count)
                        if meal.locations.count == 3 {
                            meals.append(meal)
                            currentMeal = nil
                        }
                    }
                    readingHall = false
                    readingSect = false
                    readingFood = false
                    currentHall = nil
                    currentSect = nil
                    currentFood = nil
                case DiningHall.startTag:
                    if readingMeal {readingHall = true}
                case Section.startTag:
                    if readingHall {readingSect = true}
                case Food.startTag:
                    if readingSect {readingFood = true}
                case Food.endTag:
                    if readingFood {
                        if let food = currentFood {currentSect!.foods.append(food)}
                        currentFood = nil
                        readingFood = false
                    }
                case Section.endTag:
                    if readingSect {
                        if let sect = currentSect {currentHall!.sections.append(sect)}
                        currentSect = nil
                        readingSect = readingFood
                    }
                    
//                    if !readingSect {currentSect = nil}
                case DiningHall.endTag:
                    if readingHall {
//                        print(currentHall?.name)
//                        print(currentMeal?.name)
                        if let hall = currentHall {currentMeal!.locations.append(hall)}
                        currentHall = nil
                        readingHall = readingSect
                    }
                    
//                    if !readingHall {currentHall = nil}
                default:
//                    print(false)
                    break
                }
            }
        }
        for i in meals {
            print(i.name)
            for j in i.locations {
                print(j.name)
                for k in j.sections {
                    print(k.name)
                    for l in k.foods {
                        print((l.name, l.allergens))
                    }
                }
            }
            print("")
        }
    }
}
task.resume()
