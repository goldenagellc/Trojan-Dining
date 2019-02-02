//
//  HallHours.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 2/1/19.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import Foundation

public func latestHours(for meal: Meal) -> Date? {
    let cal = Calendar(identifier: .gregorian)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy"
    let startOfDay = dateFormatter.date(from: meal.date)!
//    let weekday = cal.component(.weekday, from: now)

    switch (meal.name) {
    case "Breakfast": return cal.date(bySettingHour: 10, minute: 30, second: 0, of: startOfDay)
    case "Brunch": return cal.date(bySettingHour: 15, minute: 0, second: 0, of: startOfDay)
    case "Lunch": return cal.date(bySettingHour: 15, minute: 0, second: 0, of: startOfDay)
    case "Dinner": return cal.date(bySettingHour: 22, minute: 0, second: 0, of: startOfDay)
    default: return cal.date(bySettingHour: 22, minute: 0, second: 0, of: startOfDay)
    }
}

public func withinHours(for meal: Meal) -> Bool {
    guard let closingTime = latestHours(for: meal) else {return true}

    let now = Date()
    return now.compare(closingTime) == .orderedAscending
}
