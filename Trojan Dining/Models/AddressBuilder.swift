//
//  AddressBuilder.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/3/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import Foundation

final class AddressBuilder {
    static let BASE_URL = "https://hospitality.usc.edu/residential-dining-menus/?menu_date="

    private static func dateWith(daysAddedOn days: Int = 0) -> Date {
        let hours = TimeInterval(days)*24*60*60
        let today = Date()
        return today.addingTimeInterval(hours)
    }

    private static func suffixFor(daysInFuture: Int = 0) -> String {
        let date = dateWith(daysAddedOn: daysInFuture)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM/d/yyyy"
        let components = formatter.string(from: date).split(separator: "/")

        return components[0] + "+" + components[1] + "%2C+" + components[2]
    }

    private static func urlFor(daysInFuture: Int = 0) -> String {
        return BASE_URL + suffixFor(daysInFuture: daysInFuture)
    }

    public static func url(for day: Day) -> String {
        return urlFor(daysInFuture: day.rawValue)
    }

    public enum Day: Int {case today = 0, tomorrow, theNextDay}
}
