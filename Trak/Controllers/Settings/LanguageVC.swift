//
//  LanguageVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/30/21.
//

import UIKit
import SwiftUI

class LanguageVC: UIViewController {
    // MARK: - Views
    private let changeLanguageViewController = UIHostingController(rootView: ChangeLanguageView())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureSmallNavBar(withTitle: "Language".localized())
    }
    
    // MARK: - UI
    func layoutUI() {
        self.addChild(changeLanguageViewController)
        self.view.addSubview(changeLanguageViewController.view)
        self.changeLanguageViewController.didMove(toParent: self)
        changeLanguageViewController.view.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
}
