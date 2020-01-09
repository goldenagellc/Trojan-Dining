//
//  StarRatingView.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/7/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import UIKit

@IBDesignable class StarRatingView: UIStackView {
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {setupButtons()}
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {setupButtons()}
    }
    
    private var starButtons = [UIButton]()
    var rating = 0 {
        didSet {updateButtonSelectionStates()}
    }
    private var starButtonCallbacks: [(Int) -> ()] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    public func addStarButtonCallback(_ callback: @escaping (Int) -> ()) {
        starButtonCallbacks.append(callback)
    }
    public func clearStarButtonCallbacks() {
        starButtonCallbacks = []
    }
    
    private func setupButtons() {
        for button in starButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starButtons.removeAll()
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            button.tintColor = .label
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.setImage(UIImage(systemName: "star.fill"), for: .selected)
            button.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
            
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            button.contentMode = .scaleAspectFit
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(StarRatingView.ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            starButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = starButtons.firstIndex(of: button) else {return}
        let selectedRating = index + 1
        rating = rating == selectedRating ? 0 : selectedRating
        for callback in starButtonCallbacks {callback(rating)}
    }

    private func updateButtonSelectionStates() {
        for (index, button) in starButtons.enumerated() {button.isSelected = index < rating}
    }
}
