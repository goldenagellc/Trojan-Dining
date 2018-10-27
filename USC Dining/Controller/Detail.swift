//
//  DetailViewController.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/24/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class Detail: UIViewController {
    
    // Container
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    // Header
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {return true}
    
    internal func positionContainer(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        containerLeadingConstraint.constant = left
        containerTrailingConstraint.constant = right
        containerTopConstraint.constant = top
        containerBottomConstraint.constant = bottom
        view.layoutIfNeeded()
    }
    
    internal func setHeaderHeight(height: CGFloat) {
        headerImageHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    internal func configureRoundedCorners(shouldRound: Bool) {
        headerImageView.layer.cornerRadius = shouldRound ? RoundedCard.cornerRadius : 0.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
