//
//  BasicSettingsCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/10/21.
//

import UIKit

let basicSettingCellId = "BasicSettingsCell"

class BasicSettingsCell: UITableViewCell {
    // MARK: - Properties
    var settingsOption: SettingsOption? {
        didSet {
            guard let option = settingsOption else { return }
            iconImageView.image = UIImage(systemName: option.image)
            settingsLabel.text = option.name
            view.backgroundColor = option.color
        }
    }
    
    // MARK: - Views
    let view = UIView()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let settingsLabel = UILabel.createLabel(withTitle: "Notifications", textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.medium16, andAlignment: .left)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        view.layer.cornerRadius = 8
        backgroundColor = UIColor(named: "SettingsCellColor")
        layoutViews()
    }
    
    func layoutViews() {
        addSubviews(view, iconImageView, settingsLabel)
        
        view.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.5, hMult: 0.5)
        view.center(to: self, by: .centerY)
        view.anchor(left: leftAnchor, paddingLeft: 15)
        
        iconImageView.setDimension(width: view.heightAnchor, height: view.heightAnchor, wMult: 0.65, hMult: 0.65)
        iconImageView.center(to: view, by: .centerY)
        iconImageView.center(to: view, by: .centerX)
        
        settingsLabel.center(to: iconImageView, by: .centerY)
        settingsLabel.anchor(left: iconImageView.rightAnchor, paddingLeft: 20)
    }
}
