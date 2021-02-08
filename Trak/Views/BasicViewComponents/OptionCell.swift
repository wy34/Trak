//
//  MoreActionCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/6/21.
//

import UIKit

class OptionCell: UITableViewCell {
    // MARK: - Properties
    var moreAction: Option<Action>? = nil {
        didSet {
            guard let action = moreAction else { return }
            nameLabel.text = action.title.rawValue.localized()
            iconImageView.image = UIImage(systemName: action.image)
        }
    }
    
    var camerAction: Option<UIImagePickerController.SourceType>? = nil {
        didSet {
            guard let action = camerAction else { return }
            nameLabel.text = action.title == .camera ? "Camera".localized() : "Photo Library".localized()
            iconImageView.image = UIImage(systemName: action.image)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray : .clear
        }
    }
    
    static let reuseId = "OptionCell"
    
    // MARK: - Views
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium13!)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(named: "InvertedDarkMode")
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = UIColor(named: "InvertedDarkMode")
        return iv
    }()
    
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
        backgroundColor = .clear
        addBlurBackground(withStyle: .systemUltraThinMaterial)
        addSubview(iconImageView)
        iconImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.4, hMult: 0.4)
        iconImageView.center(y: centerYAnchor)
        iconImageView.anchor(left: leftAnchor, paddingLeft: 15)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: iconImageView.rightAnchor, paddingLeft: 10)
    }
}
