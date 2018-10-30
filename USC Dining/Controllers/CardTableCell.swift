//
//  TableViewCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardTableCell: UITableViewCell {
    
    static let ON_PRESS_SCALE_FACTOR: CGFloat = 0.96
    
    //MARK: Properties
    @IBOutlet weak var cardView: CardView!
    
    private var card: Card? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hideBuiltInViews()
        configureTapped(color: UIColor.clear)
        
        cardView.attachContentTo(self.frame)// enlarge meal canvas to fill cell
        cardView.roundCorners()
        cardView.enableShadow()
        
        self.addSubview(cardView)
    }
    
    private func hideBuiltInViews() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
    }
    
    private func configureTapped(color: UIColor) {
        if self.selectedBackgroundView != nil {self.selectedBackgroundView!.backgroundColor = color}
        else {
            let tappedView = UIView()
            tappedView.backgroundColor = color
            self.selectedBackgroundView = tappedView
        }
    }
    
    func setData(toCard card: Card) {
        self.card = card
        cardView.label_title.text = card.title
        cardView.label_subtitle.text = card.subtitle
        cardView.label_description.text = card.description
    }
    
    func updateContent(isPressed pressed: Bool) {
        if pressed {
            cardView.image.image = card!.image.resize(byScaleFactor: CardTableCell.ON_PRESS_SCALE_FACTOR)
            cardView.label_title.font = UIFont.systemFont(ofSize: 36*CardTableCell.ON_PRESS_SCALE_FACTOR, weight: .bold)
            cardView.label_subtitle.font = UIFont.systemFont(ofSize: 18*CardTableCell.ON_PRESS_SCALE_FACTOR, weight: .semibold)
        }else {
            cardView.image.image = card!.image
            cardView.label_title.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            cardView.label_subtitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
}

extension UIImage {
    func resize(byScaleFactor scaleFactor: CGFloat) -> UIImage {
        let image: UIImage = self
        let height = image.size.height*scaleFactor
        let width = image.size.width*scaleFactor
        
        let scaledSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
