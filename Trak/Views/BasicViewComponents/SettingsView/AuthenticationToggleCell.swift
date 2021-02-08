//
//  DarkModeCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/10/21.
//

import UIKit

let authToggleCellId = "authToggleCellId"

class AuthenciationToggleCell: BasicSettingsCell {
    // MARK: - Views
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch.createGraySwitch()
        toggle.onTintColor = .systemGreen
        toggle.addTarget(self, action: #selector(turnOnOffAuthentication), for: .valueChanged)
        return toggle
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupToggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        addSubview(toggle)
        toggle.frame = CGRect(x: 0, y: 0, width: frame.width * 0.1, height: 10)
        toggle.frame.origin.y = frame.height / 2 - toggle.frame.height / 2
        toggle.frame.origin.x = frame.width - (toggle.frame.width + 15)
    }
    
    private func setupToggle() {
        if UserDefaults.standard.bool(forKey: authUDKey) == true {
            toggle.isOn = true
        }
    }
    
    // MARK: - Selectors
    @objc private func turnOnOffAuthentication() {
        if toggle.isOn {
            UserDefaults.standard.setValue(true, forKey: authUDKey)
        } else {
            UserDefaults.standard.removeObject(forKey: authUDKey)
        }
    }
}
