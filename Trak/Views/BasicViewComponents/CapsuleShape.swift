//
//  CapsuleShape.swift
//  TrackingApp
//
//  Created by William Yeung on 1/22/21.
//

import UIKit

class CapsuleShape: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // draw shape
        let bz = UIBezierPath(roundedRect: CGRect(x: frame.width / 2 - (frame.width * 0.85) / 2, y: frame.height / 2 - 5, width: frame.width * 0.85, height: 10), cornerRadius: 5)
        
        // gradient
        let context = UIGraphicsGetCurrentContext()!
        let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor] as CFArray, locations: [0, 1])!
        context.saveGState()
        bz.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.width, y: 0), options: [])
        context.restoreGState()
    }
}
