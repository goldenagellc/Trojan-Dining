//
//  WebScraper.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import Foundation

class WebScraper {
    private let parent: TableViewController
    private let address: String
    private let url: URL
    private let menuBuilder: MenuBuilder
    private var task: URLSessionDataTask? = nil
    
    public init(_ delegate: TableViewController) {
        parent = delegate
        address = "https://hospitality.usc.edu/residential-dining-menus/?menu_date=October+22%2C+2018"
        url = URL(string: address)!
        menuBuilder = MenuBuilder()
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            // error handling part 1
            if let error = error {return}
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
                
                if currentNonTag.count > 0 {self.menuBuilder.processNewText(currentNonTag)}
                
                if currentNonTag == "Legend" {self.menuBuilder.saveMeal()}
                
                currentNonTag = ""
            }
            
            if readingTag {currentTag.append(char)}
            else {currentNonTag.append(char)}
            
            if char == ">" {
                readingTag = false
                self.menuBuilder.processNewTag(currentTag)
            }
        }
    }
    
    private func propagateMenuChanges() {
        //DEBUG
        let menu = menuBuilder.getMenu()
        for meal in menu {
            print(meal.name)
            for hall in meal.locations {
                print(hall.name)
                for sect in hall.sections {
                    print(sect.name)
                    for food in sect.foods {
                        print(food.name)
                    }
                }
            }
            print("")
        }
        
        parent.updateMenu(with: menu)
    }
    
    public func resume() {
        task!.resume()
    }
}
