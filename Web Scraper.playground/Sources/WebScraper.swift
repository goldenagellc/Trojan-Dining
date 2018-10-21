//
//  WebScraper.swift
//
//
//  Created by Hayden Shively on 10/19/18.
//

import Foundation



//public protocol HTMLFilter {
//    func apply(to string: String) -> String
//}
//
//public class MenuExtractor: HTMLFilter {
//    static let BODY_BEGIN: String = "<body"
//    static let FOOD_BEGIN: String = "div class=\"fw-accordion-custom meal-section"
//    static let MEAL_BEGIN: String = "<span class=\"fw-accordion-title-inner"
//    static let HALL_BEGIN: String = "<h3 class=\"menu-venue-title"
//
//
//    private let diningHalls: [Int]
//
//    public init(diningHalls: [Int] = [0, 1, 2]) {
//        self.diningHalls = diningHalls
//    }
//
//    public func apply(to string: String) -> String {
//
//        var currentTag = ""
//        var reading = false
//        var foundBody = false
//        var foundFood = false
//        var mealCount = 0
//        var hallCount = 0
//
//        for char in string {
//            if char == "<" {
//                reading = true
//                currentTag = ""
//            }
//
//            if reading {currentTag.append(char)}
//
//            if char == ">" {
//                if currentTag.contains("<body") {foundBody = true}
//                if currentTag.contains("div class=\"fw-accordion-custom meal-section") {foundFood = true}
//                if currentTag.contains("<span class=\"fw-accordion-title-inner") {mealCount += 1}
//                if currentTag.contains("<h3 class=\"menu-venue-title") {hallCount += 1}
//                if foundBody && foundFood {print(currentTag)}
//                reading = false
//            }
//
//        }
//
//        return string
//    }
//}
//
//public func Scrape(address: String, filter: HTMLFilter = MenuExtractor()) -> [[String]] {
//    var result: String = ""
//
//    let url = URL(string: address)!
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {return}//TODO
//        guard let httpResponse = response as? HTTPURLResponse,
//            (200...299).contains(httpResponse.statusCode) else {return}//TODO
//
//        if let mimeType = httpResponse.mimeType, mimeType == "type/html",
//            let data = data,
//            let string = String(data: data, encoding: .utf8) {
//
//            result = filter.apply(to: string)
//
//        }
//    }
//    task.resume()
//
//    return [[result]]
//}


