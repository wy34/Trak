//
//  TextViewWithImage.swift
//  TrackingApp
//
//  Created by William Yeung on 12/8/20.
//

import UIKit

class TextViewWithImage: UITextView {
    var leftImage: UIImage? {
        didSet {
            guard let leftImage = leftImage else { return }
            self.applyLeftImage(leftImage)
        }
    }

    fileprivate func applyLeftImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(named: "InvertedDarkMode")
        imageView.frame = CGRect(x: 0, y: 10, width: image.size.width + 20, height: image.size.height)
        imageView.contentMode = .center
        self.addSubview(imageView)
        self.textContainerInset = UIEdgeInsets(top: 8, left: image.size.width + 15, bottom: 8, right: 8)
    }
}
