//
//  UIViewController.swift
//  TrackingApp
//
//  Created by William Yeung on 1/6/21.
//

import UIKit
import UserNotifications

extension UIViewController {
    func configureLargeNavBar(withTitle title: String, andBackButtonTitle bbTitle: String) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold25!)]
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: bbTitle, style: .plain, target: nil, action: nil)
    }
    
    func configureSmallNavBar(withTitle title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)]
        navigationItem.title = title
    }
}
