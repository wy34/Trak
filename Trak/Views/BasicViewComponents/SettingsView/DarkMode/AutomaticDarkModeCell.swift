//
//  AutomaticDarkModeCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/13/21.
//

import UIKit

class AutomaticDarkModeCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "AutomaticDarkModeCellId"
    
    // MARK: - Views
    private let headerLabel = UILabel.createLabel(withTitle: "Automatic".localized(), textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.bold16, andAlignment: .left)
    private let descriptionLabel = UILabel.createLabel(withTitle: "When enabled, Trak will match your iOS appearance.".localized(), textColor: .systemGray, font: UIFont.medium14, andAlignment: .left)
    
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(turnOnOffAutomaticDarkMode), for: .valueChanged)
        return toggle
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        backgroundColor = UIColor(named: "SettingsCellColor")
        descriptionLabel.numberOfLines = 0
        layoutViews()
    }
    
    func layoutViews() {
        addSubviews(headerLabel, descriptionLabel)
        headerLabel.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.715, hMult: 0.2)
        headerLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        descriptionLabel.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.715, hMult: 0.65)
        descriptionLabel.anchor(bottom: bottomAnchor, left: leftAnchor, paddingBottom: 8, paddingLeft: 12)
    }
    
    override func layoutSubviews() {
        addSubviews(toggle)
        toggle.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        toggle.frame.origin.y = frame.height / 2 - (toggle.frame.height / 2)
        toggle.frame.origin.x = frame.width - (toggle.frame.width + 12)
    }
    
    // MARK: - Selector
    @objc func turnOnOffAutomaticDarkMode() {
        NotificationCenter.default.post(name: Notification.Name.didSwitchAutomaticDarkMode, object: nil)
    }
}
