import UIKit

import Foundation


// set address to scrape
var address: String = "https://hospitality.usc.edu/residential-dining-menus/?menu_date=October+21%2C+2018"
let url = URL(string: address)!

let menuBuilder = MenuBuilder()

let task = URLSession.shared.dataTask(with: url) { data, response, error in
    // error handling part 1
    if let error = error {return}
    // error handling part 2
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {return}
    // success
    if let mimeType = httpResponse.mimeType, mimeType == "text/html",
        let data = data,
        let html = String(data: data, encoding: .utf8) {
        
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
        
        return
    }
}
task.resume()

sleep(30)
for i in menuBuilder.getMenu() {
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
