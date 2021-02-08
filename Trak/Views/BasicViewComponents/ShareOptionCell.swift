//
//  ShareOptionCell.swift
//  TrackingApp
//
//  Created by William Yeung on 12/30/20.
//

import UIKit

class ShareOptionCell: UICollectionViewCell {
    // MARK: - Properties
    var shareOption: ShareOption? {
        didSet {
            guard let shareOption = shareOption else { return }
            optionImage.image = shareOption.image
            optionName.text = shareOption.optionName
        }
    }
    
    static let reuseId = "ShareOptionCell"
    
    private let optionImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let optionName = UILabel.createLabel(withTitle: "", textColor: nil, font: UIFont.bold10, andAlignment: .center)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configureUI() {
        addSubviews(optionImage, optionName)
        optionImage.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.5, hMult: 0.5)
        optionImage.anchor(top: topAnchor)
        optionImage.center(to: self, by: .centerX)
        
        optionName.anchor(top: optionImage.bottomAnchor, paddingTop: 5)
        optionName.setDimension(width: widthAnchor, wMult: 0.75)
        optionName.center(to: optionImage, by: .centerX)
    }
}
