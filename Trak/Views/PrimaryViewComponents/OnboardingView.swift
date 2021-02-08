//
//  OnboardingView.swift
//  TrackingApp
//
//  Created by William Yeung on 2/6/21.
//

import UIKit


class OnboardingPage: UIView {
    // MARK: - Properties
    var item: OnboardingItem? {
        didSet {
            guard let item = item else { return }
            imageView.image = UIImage(named: item.imageName)
            descriptionLabel.text = item.description
            
            for (index, letter) in item.title.enumerated() {
                Timer.scheduledTimer(withTimeInterval: 0.2 * Double(index), repeats: false) { (_) in
                    self.titleLabel.text?.append(letter)
                }
            }
        }
    }
    
    // MARK: - Views
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "track")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel = UILabel.createLabel(withTitle: "", textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.bold28, andAlignment: .center)
    private let descriptionLabel = UILabel.createLabel(withTitle: "", textColor: .systemGray, font: UIFont.bold14, andAlignment: .center)
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "StandardDarkMode")
        self.frame = frame
        layoutViews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        descriptionLabel.numberOfLines = 5
    }
    
    func layoutViews() {
        addSubviews(imageView, labelStack)
        
        imageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.45, hMult: 0.45)
        imageView.center(to: self, by: .centerX)
        imageView.center(to: self, by: .centerY, withMultiplierOf: 0.75)
        
        labelStack.setDimension(width: widthAnchor, wMult: 0.75)
        labelStack.center(to: imageView, by: .centerX)
        labelStack.center(to: self, by: .centerY, withMultiplierOf: 1.2)
    }
}

