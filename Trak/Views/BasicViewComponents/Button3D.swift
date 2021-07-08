//
//  3DButton.swift
//  TrackingApp
//
//  Created by William Yeung on 1/1/21.
//

import UIKit

protocol Button3DDelegate: AnyObject {
    func handleUnitSwitch(isDown: Bool)
}

class Button3D: UIView {
    // MARK: - Properties
    var isDown = false
    var buttonCenterYConstraint: NSLayoutConstraint!
    weak var delegate: Button3DDelegate?
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Views
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("m", for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(pressed), for: .touchDown)
        return button
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
  
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.cornerRadius = 5
    }

    private func layoutViews() {
        addSubview(button)
        button.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.9, hMult: 0.9)
        button.center(x: centerXAnchor)
        buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3)
        buttonCenterYConstraint.isActive = true
    }
    
    // MARK: - Selectors
    @objc func pressed() {
        isDown.toggle()
        haptics.impactOccurred()
        
        if isDown {
            self.button.setTitleColor(#colorLiteral(red: 0.3328248262, green: 0.3615880013, blue: 0.4001142979, alpha: 1), for: .normal)
            self.button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.buttonCenterYConstraint.constant = 0
        } else {
            self.button.setTitleColor(.white, for: .normal)
            self.button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.buttonCenterYConstraint.constant = -3
        }
        
        delegate?.handleUnitSwitch(isDown: self.isDown)
    }
}
