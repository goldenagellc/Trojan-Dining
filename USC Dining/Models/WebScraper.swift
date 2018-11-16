//
//  WebScraper.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import Foundation

class WebScraper {
    private let url: URL
    private let callback: ([Meal]) -> Void
    private let menuBuilder: MenuBuilder
    private var task: URLSessionDataTask? = nil
    
    public init(forURL url: String, callback: @escaping ([Meal]) -> Void) {
        self.url = URL(string: url)!
        self.callback = callback
        self.menuBuilder = MenuBuilder()
        
        task = URLSession.shared.dataTask(with: self.url) { data, response, error in
            // error handling part 1 TODO
            // guard let error = error else {return}
            // error handling part 2
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {return}
            // success
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let html = String(data: data, encoding: .utf8) {
                
                self.scrape(html)
                self.propagateMenuChanges()
                
                return
            }
        }
    }
    
    private func scrape(_ html: String) {
        var readingTag: Bool = false
        var currentTag: String = ""
        var currentNonTag: String = ""
        
        for char in html {
            // for finding html tags
            if char == "<" {
                readingTag = true
                currentTag = ""
                
                if currentNonTag.count > 0 {menuBuilder.processNewText(currentNonTag)}
                if currentNonTag == "Legend" {menuBuilder.saveMeal()}
                currentNonTag = ""
            }
            
            if readingTag {currentTag.append(char)}
            else {currentNonTag.append(char)}
            
            if char == ">" {
                readingTag = false
                menuBuilder.processNewTag(currentTag)
            }
        }
    }
    
    private func propagateMenuChanges() {
        var menu: [Meal] = []
        for htmlMeal in menuBuilder.mealHierarchy() {menu.append(Meal(fromHTMLMeal: htmlMeal))}

        callback(menu)
    }
    
    public func resume() {task!.resume()}
}
