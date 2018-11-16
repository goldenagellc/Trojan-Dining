//
//  ViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 11/10/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var filterViewConstraint_amountOffScreen: NSLayoutConstraint!

    private var mealViews = [CardView]()

    private var menuToday: [Meal] = []
    private var menuTomorrow: [Meal] = []
    private var menuTheNextDay: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scraperToday = WebScraper(forURL: AddressBuilder.url(for: .today)) {menu in
            DispatchQueue.main.async {self.menuToday = menu; self.reloadDataIfReady()}
        }
        let scraperTomorrow = WebScraper(forURL: AddressBuilder.url(for: .tomorrow)) {menu in
            DispatchQueue.main.async {self.menuTomorrow = menu; self.reloadDataIfReady()}
        }
        let scraperTheNextDay = WebScraper(forURL: AddressBuilder.url(for: .theNextDay)) {menu in
            DispatchQueue.main.async {self.menuTheNextDay = menu; self.reloadDataIfReady()}
        }
        scraperToday.resume()
        scraperTomorrow.resume()
        scraperTheNextDay.resume()


        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
    }

    func reloadDataIfReady() {
        let menu = (menuToday + menuTomorrow + menuTheNextDay).filter {$0.isServed}
        let mealCount = menu.count

        scrollView.contentSize = CGSize(width: scrollView.frame.width*CGFloat(mealCount), height: scrollView.frame.height)

        let xInset: CGFloat = 20

        for i in 0 ..< mealCount {
            let frame = CGRect(x: (xInset + scrollView.frame.width*CGFloat(i))/2, y: 0, width: scrollView.frame.width - xInset*2, height: scrollView.frame.height)
            let mealView = CardView(frame: frame, mealData: menu[i])// TODO no reason to rebuild every card every time reload gets called

            mealViews.append(mealView)
            scrollView.addSubview(mealView)
        }

        scrollView.setNeedsDisplay()
        print("Got cards")
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
