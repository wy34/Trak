//
//  UILabel.swift
//  TrackingApp
//
//  Created by William Yeung on 1/1/21.
//

import UIKit

extension UILabel {
    static func createHeaderLabel(withTitle title: String, andFont font: UIFont?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.textColor = UIColor(named: "InvertedDarkMode")
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font!)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    static func createCaptionLabel(withTitle title: String, withColor color: UIColor = UIColor(named: "InvertedDarkMode")!, aligned align: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = color
        if let align = align {
            label.textAlignment = align
        }
        return label
    }
    
    static func createLabel(withTitle title: String, textColor: UIColor?, font: UIFont?, andAlignment alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        if let font = font {
            label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        }
        label.adjustsFontForContentSizeCategory = true
        if let textColor = textColor {
            label.textColor = textColor
        }
        return label
    }
    
    static func createSnapshotOverlayLabels(withColor color: UIColor = UIColor(named: "StandardDarkMode")!) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }
    
    static func createSummaryViewStatsLabels(withTitle title: String? = nil, withFont font: UIFont? = UIFont.medium11!) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.textColor = UIColor(named: "InvertedDarkMode")
        label.numberOfLines = 0
        label.backgroundColor = .systemGray6
        label.font = font
        return label
    }
}

