//
//  UIApplication.swift
//  TrackingApp
//
//  Created by William Yeung on 12/7/20.
//

import UIKit

extension UIApplication {
    static func tabBarController() -> RootTabBarController? {
        return shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? RootTabBarController
    }
}
