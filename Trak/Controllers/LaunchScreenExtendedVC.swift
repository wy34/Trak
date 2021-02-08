//
//  LaunchScreenExtendedVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/20/21.
//

import UIKit

class LaunchScreenExtendedView: UIView {
    // MARK: - Views
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "logo")
        return iv
    }()
    
    let unlockBtn = UIButton.createLaunchScreenButton(withTitle: "Unlock", bgColor: .systemGray, andFont: UIFont.bold16)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2, green: 0.1882352941, blue: 0.2274509804, alpha: 1)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        unlockBtn.isHidden = true
        unlockBtn.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        layoutViews()
    }
    
    func layoutViews() {
        addSubviews(imageView, unlockBtn)
        imageView.setDimension(wConst: 100, hConst: 100)
        imageView.center(x: centerXAnchor)
        imageView.center(to: self, by: .centerY, withMultiplierOf: 0.6)
        
        unlockBtn.anchor(right: rightAnchor, left: leftAnchor, paddingRight: 45, paddingLeft: 45)
        unlockBtn.center(to: self, by: .centerY, withMultiplierOf: 1.65)
        unlockBtn.setDimension(hConst: 45)
    }
    
    
    // MARK: - Selector
    @objc func authenticate() {
        unlockBtn.isHidden = true
        UIApplication.tabBarController()?.authenticate()
    }
}
