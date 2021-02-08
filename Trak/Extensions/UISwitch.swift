//
//  UISwitch.swift
//  TrackingApp
//
//  Created by William Yeung on 2/4/21.
//

import UIKit

extension UISwitch {
    static func createGraySwitch() -> UISwitch {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGray3
        toggle.isOn = false
        return toggle
    }
}
