//
//  UIView.swift
//  TrackingApp
//
//  Created by William Yeung on 11/20/20.
//

import UIKit

enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    // MARK: - Anchors
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, paddingTop:  CGFloat = 0, paddingRight: CGFloat = 0, paddingBottom: CGFloat = 0, paddingLeft: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
    }
    
    func setDimension(wConst: CGFloat? = nil, hConst: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let wConst = wConst {
            widthAnchor.constraint(equalToConstant: wConst).isActive = true
        }
        
        if let hConst = hConst {
            heightAnchor.constraint(equalToConstant: hConst).isActive = true
        }
    }
    
    func setDimension(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, wMult: CGFloat = 1, hMult: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: wMult).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: hMult).isActive = true
        }
    }
    
    func center(x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil, xPadding: CGFloat = 0, yPadding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: xPadding).isActive = true
        }
        
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: yPadding).isActive = true
        }
    }
    
    func center(to view2: UIView, by attribute: NSLayoutConstraint.Attribute, withMultiplierOf mult: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view2, attribute: attribute, multiplier: mult, constant: 0).isActive = true
        
    }
    
    // MARK: - Border
    func addBorder(toSide side: BorderSide, withColor color: UIColor, andDimension dimension: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)

        let topConstraint = border.topAnchor.constraint(equalTo: topAnchor)
        let rightConstraint = border.rightAnchor.constraint(equalTo: rightAnchor)
        let bottomConstraint = border.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leftConstraint = border.leftAnchor.constraint(equalTo: leftAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: dimension)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: dimension)

        switch side {
            case .top:
                NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
            case .right:
                NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
            case .bottom:
                NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
            case .left:
                NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
    
    func addLeftCellBorder(withColor color: UIColor, width: CGFloat, height: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)
        
        let leftConstraint = border.leftAnchor.constraint(equalTo: leftAnchor)
        let centerYConstaint = border.centerYAnchor.constraint(equalTo: centerYAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: height)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
        
        NSLayoutConstraint.activate([leftConstraint, centerYConstaint, widthConstraint, heightConstraint])
    }

    
    static func createBlueBorderLine() -> UIView {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor, #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 4)
        return view
    }
    
    // MARK: - Create Basic View
    static func createView(withBgColor bgColor: UIColor, alpha: CGFloat, andCornerRadius cr: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        view.alpha = alpha
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        view.layer.cornerRadius = cr
        return view
    }
    
    // MARK: - Blur
    func addBlurBackground(withStyle style: UIBlurEffect.Style) {
        let blur = UIBlurEffect(style: style)
        let effect = UIVisualEffectView(effect: blur)
        effect.frame = self.bounds
        effect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(effect)
    }
}

