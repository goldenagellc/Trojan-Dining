//
//  TodayViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/24/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class Today: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal let presentDetail = PresentDetail()
    internal let dismissDetail = DismissDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure(collectionView: collectionView)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        destination.transitioningDelegate = self
    }
    

}

extension Today: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentDetail
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissDetail
    }
}
