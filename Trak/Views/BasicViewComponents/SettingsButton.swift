//
//  SettingsButton.swift
//  TrackingApp
//
//  Created by William Yeung on 1/8/21.
//

import UIKit

class SettingsButton: UIButton {
    // MARK: - Views
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5851885676, green: 0.5996479988, blue: 0.5989565253, alpha: 1)
        return label
    }()
    
    private let buttonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.5851885676, green: 0.5996479988, blue: 0.5989565253, alpha: 1)
        return iv
    }()
    
    // MARK: - Init
    init(withTitle title: String, andImage image: String) {
        super.init(frame: .zero)
        configureUI(buttonTitle: title, buttonImage: image)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI(buttonTitle: String, buttonImage: String) {
        buttonLabel.text = buttonTitle
        buttonImageView.image = UIImage(systemName: buttonImage)
    }
    
    private func layoutViews() {
        addSubviews(buttonImageView, buttonLabel)
        
        buttonImageView.center(to: self, by: .centerX)
        buttonImageView.center(to: self, by: .centerY, withMultiplierOf: 0.8)
        buttonImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.55, hMult: 0.55)
        
        buttonLabel.anchor(right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        buttonLabel.setDimension(height: heightAnchor, hMult: 0.275)
    }
}
