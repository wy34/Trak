//
//  ProfileCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/12/21.
//

import UIKit

let profileCellId = "ProfileCell"

class ProfileCell: UITableViewCell {
    // MARK: - Properties
    var settingsOption: SettingsOption? {
        didSet {
            guard let option = settingsOption else { return }
            profileImageView.image = UIImage(systemName: option.image)
            setupName()
            setupImage()
        }
    }
    
    // MARK: - Views
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "person.circle")
        iv.tintColor = UIColor(named: "InvertedDarkMode")
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel = UILabel.createLabel(withTitle: "William Yeung", textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.medium16, andAlignment: .left)
    private let descriptionLabel = UILabel.createLabel(withTitle: "Edit Profile".localized(), textColor: .systemGray, font: UIFont.medium12, andAlignment: .left)
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNameLabel), name: Notification.Name.didChangeName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: Notification.Name.didChangeImage, object: nil)
        layoutViews()
        backgroundColor = UIColor(named: "SettingsCellColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(profileImageView, labelStack)
    
        profileImageView.setDimension(wConst: 50, hConst: 50)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 15)
        profileImageView.center(to: self, by: .centerY)
        profileImageView.layer.cornerRadius = 50 / 2
        
        labelStack.anchor(right: rightAnchor, left: profileImageView.rightAnchor, paddingRight: 40, paddingLeft: 15)
        labelStack.center(to: profileImageView, by: .centerY)
    }
    
    func setupImage() {
        guard let imageData = UserDefaults.standard.data(forKey: imageUDKey) else { return }
        profileImageView.image = UIImage(data: imageData)
    }
    
    func setupName() {
        guard let name = UserDefaults.standard.string(forKey: nameUDKey) else { nameLabel.text = "Your Name".localized(); return }
        nameLabel.text = name
    }
    
    // MARK: - Selectors
    @objc func updateNameLabel(notification: Notification) {
        if let newName = notification.userInfo?["newName"] as? String {
            nameLabel.text = newName
        }
    }
    
    @objc func updateImage(notification: Notification) {
        if let newImageData = notification.userInfo?["newImage"] as? Data {
            profileImageView.image = UIImage(data: newImageData)
        }
    }
}
