//
//  UIButton.swift
//  TrackingApp
//
//  Created by William Yeung on 1/1/21.
//

import UIKit

extension UIButton {
    static func createControlButtons(withImage image: String? = nil, withTitle title: String? = nil, andTintColor tc: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        
        if let image = image {
            button.setImage(UIImage(systemName: image), for: .normal)
        }
        
        button.tintColor = tc
        return button
    }
    
    static func createWorkoutButtons(withTitle title: String, bgColor: UIColor, isFinishButton: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = bgColor
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.labelFontSize!)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        if isFinishButton {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.isHidden = true
            button.alpha = 0
        }
        
        return button
    }
    
    static func createSummaryViewMainButtons(withTitle title: String, bgColor: UIColor, andFont font: UIFont?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font!)
        return button
    }
    
    static func createLaunchScreenButton(withTitle title: String, bgColor: UIColor, andFont font: UIFont?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font!)
        return button
    }
    
    static func createMapButtons(withImage image: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.StandardDarkMode
        button.layer.shadowColor = UIColor(white: 0.25, alpha: 0.75).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.cornerRadius = 12
        button.tintColor = UIColor.InvertedDarkMode
        button.setImage(UIImage(systemName: image), for: .normal)
        return button
    }
    
    static func createMusicControls(withImage image: String, isPlayPause: Bool) -> UIButton {
        var config: UIImage.SymbolConfiguration!
        let button = UIButton(type: .system)
        
        if isPlayPause {
            config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: UIScreen.main.bounds.height <= 736 ? 18 : 24))
        } else {
            config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: UIScreen.main.bounds.height <= 736 ? 12 : 14))
        }
        
        button.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
        button.tintColor = UIColor.InvertedDarkMode
        return button
    }
    
    static func createScrollButtons(withImage img: String, andTag tag: Int) -> UIButton {
        let button = UIButton.createControlButtons(withImage: img, andTintColor: UIColor.InvertedDarkMode.withAlphaComponent(0.15))
        button.tag = tag
        button.isHidden = tag == 1 ? true : false
        return button
    }
}
