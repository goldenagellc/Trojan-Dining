import Foundation

public class MenuBuilder {
    
    private var menu: [Meal] = []
    
    var currentMeal: Meal?
    var currentHall: DiningHall?
    var currentSect: Section?
    var currentFood: Food?
    
    var readingMeal: Bool = false
    var readingHall: Bool = false
    var readingSect: Bool = false
    var readingFood: Bool = false
    
    public init() {}
    
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
        case Meal.startTag:
            saveMeal()
            resetMeal(); resetHall(); resetSect(); resetFood();
            
        case DiningHall.startTag: if readingMeal {readingHall = true}
            
        case Section.startTag: if readingHall {readingSect = true}
            
        case Food.startTag: if readingSect {readingFood = true}
            
        case Food.endTag: if readingFood {saveFood(); resetFood();}
            
        case Section.endTag: if readingSect {saveSect(); resetSect();}
            
        case DiningHall.endTag: if readingHall {saveHall(); resetHall();}
            
        default: break
        }
    }
    
    public func getMenu() -> [Meal] {
        return menu
    }
    
    public func mealIsNil() -> Bool {
        return currentMeal == nil
    }
    
    public func hallIsNil() -> Bool {
        return currentHall == nil
    }
    
    public func sectIsNil() -> Bool {
        return currentSect == nil
    }
    
    public func foodIsNil() -> Bool {
        return currentFood == nil
    }
    
    public func initializeMeal(withName name: String) {
        currentMeal = Meal(name: name, locations: [])
    }
    
    public func initializeHall(withName name: String) {
        currentHall = DiningHall(name: name, sections: [])
    }
    
    public func initializeSect(withName name: String) {
        currentSect = Section(name: name, foods: [])
    }
    
    public func initializeFood(withName name: String) {
        currentFood = Food(name: name, allergens: [])
    }
    
    public func saveMeal() {
        if let meal = currentMeal, meal.locations.count == 3 {menu.append(meal)}
    }
    
    private func saveHall() {
        if let hall = currentHall {currentMeal!.locations.append(hall)}
    }
    
    private func saveSect() {
        if let sect = currentSect {currentHall!.sections.append(sect)}
    }
    
    private func saveFood() {
        if let food = currentFood {currentSect!.foods.append(food)}
    }
    
    private func resetMeal() {
        currentMeal = nil; readingMeal = true;
    }
    
    private func resetHall() {
        currentHall = nil; readingHall = false;
    }
    
    private func resetSect() {
        currentSect = nil; readingSect = false;
    }
    
    private func resetFood() {
        currentFood = nil; readingFood = false;
    }
    
    
    public struct Meal {
        public let name: String
        public var locations: [DiningHall]
        
        static let startTag: String = "<span class=\"fw-accordion-title-inner\">"
    }
    
    public struct DiningHall {
        public let name: String
        public var sections: [Section]
        
        static let startTag: String = "<h3 class=\"menu-venue-title\">"
        static let endTag: String = "</div>"
    }
    
    public struct Section {
        public let name: String
        public var foods: [Food]
        
        static let startTag: String = "<h4>"
        static let endTag: String = "</ul>"
    }
    
    public struct Food {
        public let name: String
        public var allergens: [String]
        
        static let startTag: String = "<li>"
        static let endTag: String = "</li>"
    }
    
}
