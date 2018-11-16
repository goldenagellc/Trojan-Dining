//
//  DetailViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/28/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardDetailController: UIViewController {
    
    //AK: Properties
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var detailPane: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var card: Meal? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setData(toCard card: Meal) {
        self.card = card
//        cardView.image.image = card.image
        cardView.label_title.text = card.name
//        cardView.label_subtitle.text = meal.hours()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
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
