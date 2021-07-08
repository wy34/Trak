//
//  LocationRequestVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/5/21.
//

import UIKit
import CoreLocation

protocol LocationRequestOnboardingDelegate: AnyObject {
    func dismissOnboarding()
}

protocol LocationRequestDelegate: AnyObject {
    func dismissLocationRequest()
}

class BaseLocationRequestView: UIView {
    // MARK: - Properties
    var locationManager: CLLocationManager?
    weak var onboardingDelegate: LocationRequestOnboardingDelegate?
    weak var locationReqestDelegate: LocationRequestDelegate?
    
    // MARK: - Views
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Assets.route
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let letsGetStartedLabel = UILabel.createLabel(withTitle: "Let's Get Started!".localized(), textColor: UIColor.InvertedDarkMode, font: UIFont.bold14)
    private let permissionHeaderLabel = UILabel.createLabel(withTitle: "Allow Your Location".localized(), textColor: UIColor.InvertedDarkMode, font: UIFont.bold25, andAlignment: .center)
    private let permissionDescriptionLabel = UILabel.createLabel(withTitle: "Please enable location services so that we can track your activities.".localized(), textColor: .systemGray, font: UIFont.bold14, andAlignment: .center)
    
    let permissionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Allow".localized(), for: .normal)
        button.setTitleColor(UIColor.StandardDarkMode, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.InvertedDarkMode
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(allowLocationServices), for: .touchUpInside)
        return button
    }()
        
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [permissionHeaderLabel, permissionDescriptionLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    private func configureUI(){
        letsGetStartedLabel.isHidden = true
        backgroundColor = UIColor.StandardDarkMode
        permissionDescriptionLabel.numberOfLines = 0
    }
    
    private func layoutViews() {
        addSubviews(letsGetStartedLabel, iconImageView, labelStack, permissionButton)
        
        letsGetStartedLabel.center(to: self, by: .centerX)
        letsGetStartedLabel.center(to: self, by: .centerY, withMultiplierOf: 0.35)
        
        iconImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.45, hMult: 0.45)
        iconImageView.center(to: self, by: .centerX)
        iconImageView.center(to: self, by: .centerY, withMultiplierOf: 0.75)
        
        labelStack.setDimension(width: widthAnchor, wMult: 0.75)
        labelStack.center(to: iconImageView, by: .centerX)
        labelStack.center(to: self, by: .centerY, withMultiplierOf: 1.2)
        
        permissionButton.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.75, hMult: 0.05)
        permissionButton.center(to: self, by: .centerX)
        permissionButton.center(to: self, by: .centerY, withMultiplierOf: 1.5)
    }
    
    // MARK: - Selectors
    @objc func allowLocationServices() {
        guard let locationManager = locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - LocationManagerDelegate
extension BaseLocationRequestView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if OnboardingStatus.shared.isNewUser() {
            onboardingDelegate?.dismissOnboarding()
        } else {
            locationReqestDelegate?.dismissLocationRequest()
        }
    }
}
