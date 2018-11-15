//
//  CardView.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/29/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    static let CORNER_RADIUS: CGFloat = 16.0
    
    // CANVAS
    @IBOutlet var contentView: UIView!
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_subtitle: UILabel!

    
    // initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig(frame: frame)
    }
    
    // initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig(frame: frame)
    }
    
    // code to run regardless of initialization method
    private func homogeneousConfig(frame: CGRect) {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)

        attachContentTo(frame)
        roundCorners()
    }
    
    // MARK: - convenience functions
    
    func attachContentTo(_ frame: CGRect) {
        contentView.frame = frame
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func roundCorners(toRadius radius: CGFloat = CardView.CORNER_RADIUS) {
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
    }
}


//extension UIImage {
//    func resize(byScaleFactor scaleFactor: CGFloat) -> UIImage {
//        let image: UIImage = self
//        let height = image.size.height*scaleFactor
//        let width = image.size.width*scaleFactor
//
//        let scaledSize = CGSize(width: width, height: height)
//
//        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
//        image.draw(in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return scaledImage!
//    }

//    func noir() -> UIImage {
//        let context = CIContext(options: nil)
//        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")!
//        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
//        let output = currentFilter.outputImage!
//        let cgImage = context.createCGImage(output, from: output.extent)!
//        let processedImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
//
//        return processedImage
//    }
//}

//extension UIView {
//    func edges(to view: UIView, left: CGFloat = 0.0, right: CGFloat = 0.0, top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
//        NSLayoutConstraint.activate([
//        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
//        rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
//        topAnchor.constraint(equalTo: view.topAnchor, constant: top),
//        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
//        ])
//    }
//}
