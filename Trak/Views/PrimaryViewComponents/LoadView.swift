//
//  LoadView.swift
//  TrackingApp
//
//  Created by William Yeung on 12/15/20.
//

import UIKit

class LoadView: UIView {
    // MARK: - Properties
    let screen = UIScreen.main.bounds
    var underLayer = CAShapeLayer()
    var topLayer = CAShapeLayer()
    
    // MARK: - Views
    private let runImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "run")
        return iv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBlurBackground(withStyle: .light)
        drawCircle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoadProgressBar), name: .didPressFinish, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func drawCircle() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: screen.midX, y: screen.midY - 100), radius: 50, startAngle: -.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        underLayer.fillColor = UIColor.clear.cgColor
        underLayer.path = circularPath.cgPath
        underLayer.strokeColor = UIColor.systemGray.cgColor
        underLayer.lineWidth = 5
        underLayer.strokeStart = 0
        underLayer.strokeEnd = 1
        underLayer.lineCap = .round
        self.layer.addSublayer(underLayer)
        
        topLayer.fillColor = UIColor.clear.cgColor
        topLayer.path = circularPath.cgPath
        topLayer.strokeColor = UIColor.systemRed.cgColor
        topLayer.lineWidth = 5
        topLayer.strokeStart = 0
        topLayer.strokeEnd = 0
        topLayer.lineCap = .round
        self.layer.addSublayer(topLayer)
        
        addSubview(runImageView)
        runImageView.frame = CGRect(x: screen.midX - (25/2), y: screen.midY - (100 + (25/2)), width: 25, height: 25)
    }
    
    // MARK: - Selectors
    @objc func handleLoadProgressBar() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.14
        
        // keeps the stroke
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        topLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}

