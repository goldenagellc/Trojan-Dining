//
//  TableViewCell.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardTableCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: coder)
//    }
}

//class CardTableCell: UITableViewCell {
//
//    static let SHADOW_OPACITY: Float = 0.2
//    static let SHADOW_WIDTH: CGFloat = 10.0
//    static let ON_PRESS_SCALE_FACTOR: CGFloat = 0.95
//
//    //MARK: Properties
//    @IBOutlet weak var cardView: CardView!
//    private var card: Meal? = nil
//    private var insetFrame: CGRect? = nil
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        insetFrame = self.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))//self.frame.insetBy(dx: 20, dy: 10)
//
//
//        hideBuiltInViews()
//        enableShadows()
//
//        cardView.attachContentTo(insetFrame!)
//        cardView.roundCorners()
//        self.addSubview(cardView)
//    }
//
//    private func hideBuiltInViews() {
//        self.selectionStyle = .none
//        self.backgroundColor = .clear
//        self.contentView.backgroundColor = UIColor.clear
//        self.contentView.clipsToBounds = false
//    }
//
//    func setData(toCard card: Meal) {
//        self.card = card
//        cardView.label_title.text = card.name
////        cardView.label_subtitle.text = card.hours()
//    }
//
//    func getData() -> Meal? {return card}
//
//    func updateContent(isPressed pressed: Bool) {
//        if pressed {
//            cardView.label_title.font = UIFont.systemFont(ofSize: 36*CardTableCell.ON_PRESS_SCALE_FACTOR, weight: .bold)
//            cardView.label_subtitle.font = UIFont.systemFont(ofSize: 18*CardTableCell.ON_PRESS_SCALE_FACTOR, weight: .semibold)
//        }else {
//            cardView.label_title.font = UIFont.systemFont(ofSize: 36, weight: .bold)
//            cardView.label_subtitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        }
//    }
//}
//
//extension CardTableCell {// for shadows
//
//    func enableShadows(withOpacity opacity: Float = CardTableCell.SHADOW_OPACITY, withWidth radius: CGFloat = CardTableCell.SHADOW_WIDTH) {
//        layer.shadowOpacity = opacity
//        layer.shadowRadius = radius
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize.zero
//        layer.masksToBounds = false
//
//        layer.shadowPath = UIBezierPath(roundedRect: insetFrame!, cornerRadius: CardView.CORNER_RADIUS).cgPath
//    }
//
//}
//
//extension CardTableCell {// for press down animation
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        animateOnPress()
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        animateOnPress(release: true)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        animateOnPress(release: true)
//    }
//
//    func animateOnPress(release: Bool = false) {
//        let desiredTransform = release ? .identity: CGAffineTransform(scaleX: CardTableCell.ON_PRESS_SCALE_FACTOR, y: CardTableCell.ON_PRESS_SCALE_FACTOR)
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.0,
//            usingSpringWithDamping: 1.0,
//            initialSpringVelocity: 0.0,
//            options: [UIView.AnimationOptions.allowUserInteraction],
//            animations: {
//                self.transform = desiredTransform
//            },
//            completion: nil
//        )
//    }
//
//}
