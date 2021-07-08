//
//  ExerciseTypeMenu.swift
//  TrackingApp
//
//  Created by William Yeung on 12/24/20.
//

import UIKit

protocol ActivityTypeMenuDelegate: AnyObject {
    func handleMenu(isOpen: Bool, withType type: ActivityType)
}

class ActivityTypeMenu: UIView {
    // MARK: - Properties
    var isMenuOpen = false
    weak var delegate: ActivityTypeMenuDelegate?
    
    // MARK: - Views
    private lazy var openCloseMenuButton: ActivityTypeMenuButton = {
        let button = ActivityTypeMenuButton(withId: .undefined, andEmoji: "➕")
        button.alpha = 1
        button.isHidden = false
        return button
    }()
    
    private lazy var runMenuButton = ActivityTypeMenuButton(withId: .run, andEmoji: "🏃‍♂️")
    private lazy var walkMenuButton = ActivityTypeMenuButton(withId: .walk, andEmoji: "🚶‍♂️")
    private lazy var bikeMenuButton = ActivityTypeMenuButton(withId: .bike, andEmoji: "🚴‍♂️")
    private lazy var carMenuButton = ActivityTypeMenuButton(withId: .car, andEmoji: "🚙")
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [walkMenuButton, runMenuButton, openCloseMenuButton, bikeMenuButton, carMenuButton])
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupButtonTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    private func layoutUI() {
        addSubview(buttonStack)
        buttonStack.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 5, paddingRight: 5, paddingBottom: 5, paddingLeft: 5)
    }
    
    private func setupButtonTargets() {
        openCloseMenuButton.addTarget(self, action: #selector(handleOpenCloseMenu), for: .touchUpInside)
        runMenuButton.addTarget(self, action: #selector(handleRunMenu), for: .touchUpInside)
        walkMenuButton.addTarget(self, action: #selector(handleWalkMenu), for: .touchUpInside)
        bikeMenuButton.addTarget(self, action: #selector(handleBikeMenu), for: .touchUpInside)
        carMenuButton.addTarget(self, action: #selector(handleCarMenu), for: .touchUpInside)
    }
    
    func resetMenuToDefault() {
        isMenuOpen = false
        UIView.animate(withDuration: 0.3) {
            self.openCloseMenuButton.transform = CGAffineTransform(rotationAngle: 0)
            self.walkMenuButton.isHidden = true
            self.runMenuButton.isHidden = true
            self.bikeMenuButton.isHidden = true
            self.carMenuButton.isHidden = true
        }
    }
    
    func setSelectedButton(forType type: String) {
        for view in buttonStack.subviews {
            if let button = view as? ActivityTypeMenuButton {
                if button.type.rawValue == type {
                    view.alpha = 1
                    view.isHidden = false
                } else {
                    view.alpha = 0
                    view.isHidden = true
                }
            }
        }
    }
    
    private func handle(buttonTapped: ActivityTypeMenuButton) {
        if isMenuOpen == false {
            isMenuOpen = true
            UIView.animate(withDuration: 0.3) {
                self.openCloseMenuButton.transform = CGAffineTransform(rotationAngle: -.pi/4)
                for view in self.buttonStack.subviews {
                    view.alpha = 1
                    view.isHidden = false
                }
            }
        } else {
            isMenuOpen = false
            UIView.animate(withDuration: 0.3) {
                self.openCloseMenuButton.transform = CGAffineTransform(rotationAngle: 0)
                self.setSelectedButton(forType: buttonTapped.type.rawValue)
            }
        }
        
        delegate?.handleMenu(isOpen: isMenuOpen, withType: buttonTapped.type)
    }
    
    // MARK: - Selectors
    @objc func handleOpenCloseMenu() {
        handle(buttonTapped: openCloseMenuButton)
    }
    
    @objc func handleRunMenu() {
        handle(buttonTapped: runMenuButton)
    }
    
    @objc func handleWalkMenu() {
        handle(buttonTapped: walkMenuButton)
    }
    
    @objc func handleCarMenu() {
        handle(buttonTapped: carMenuButton)
    }
    
    @objc func handleBikeMenu() {
        handle(buttonTapped: bikeMenuButton)
    }
}








