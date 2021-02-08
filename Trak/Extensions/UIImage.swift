//
//  UIImage.swift
//  TrackingApp
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

extension UIImageView {
    static func createVolumeImageViews(withImage image: String) -> UIImageView {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 10))
        iv.image = UIImage(systemName: image, withConfiguration: config)
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }
}
