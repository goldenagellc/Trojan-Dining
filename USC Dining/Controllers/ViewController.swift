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

    private var cardViews = [CardView]()

    private var cardsToday = [Card]()
    private var cardsTomorrow = [Card]()
    private var cardsTheNextDay = [Card]()
    private var hasCardsToday = false
    private var hasCardsTomorrow = false
    private var hasCardsTheNextDay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scraperToday = WebScraper(forURL: AddressBuilder.url(for: .today)) {cards in
            self.cardsToday = cards
            DispatchQueue.main.async {
                self.hasCardsToday = true
                self.reloadDataIfReady()
            }
        }
        let scraperTomorrow = WebScraper(forURL: AddressBuilder.url(for: .tomorrow)) {cards in
            self.cardsTomorrow = cards
            DispatchQueue.main.async {
                self.hasCardsTomorrow = true
                self.reloadDataIfReady()
            }
        }
        let scraperTheNextDay = WebScraper(forURL: AddressBuilder.url(for: .theNextDay)) {cards in
            self.cardsTheNextDay = cards
            DispatchQueue.main.async {
                self.hasCardsTheNextDay = true
                self.reloadDataIfReady()
            }
        }
        scraperToday.resume()
        scraperTomorrow.resume()
        scraperTheNextDay.resume()


        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
    }

    func reloadDataIfReady() {
        if hasCardsToday && hasCardsTomorrow && hasCardsTheNextDay {
            let totalCardCount = cardsToday.count + cardsTomorrow.count + cardsTheNextDay.count
            scrollView.contentSize = CGSize(width: scrollView.frame.width*CGFloat(totalCardCount), height: scrollView.frame.height)

            var xOffset: CGFloat = 0

            for i in 0 ..< cardsToday.count {
                let cardView = CardView(frame: CGRect(x: xOffset + scrollView.frame.width*CGFloat(i)/2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                cardView.label_title.text = cardsToday[i].title
                cardView.label_subtitle.text = cardsToday[i].subtitle

                cardViews.append(cardView)
                scrollView.addSubview(cardView)
            }

            xOffset += scrollView.frame.width*CGFloat(cardsToday.count)/2

            for i in 0 ..< cardsTomorrow.count {
                let cardView = CardView(frame: CGRect(x: xOffset + scrollView.frame.width*CGFloat(i)/2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                cardView.label_title.text = cardsTomorrow[i].title
                cardView.label_subtitle.text = cardsTomorrow[i].subtitle

                cardViews.append(cardView)
                scrollView.addSubview(cardView)
            }

            xOffset += scrollView.frame.width*CGFloat(cardsTomorrow.count)/2

            for i in 0 ..< cardsTheNextDay.count {
                let cardView = CardView(frame: CGRect(x: xOffset + scrollView.frame.width*CGFloat(i)/2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                cardView.label_title.text = cardsTheNextDay[i].title
                cardView.label_subtitle.text = cardsTheNextDay[i].subtitle

                cardViews.append(cardView)
                scrollView.addSubview(cardView)
            }

            scrollView.setNeedsDisplay()
            print("Got cards")
        }
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
