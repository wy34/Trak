//
//  UpsideDownCommentView.swift
//  TrackingApp
//
//  Created by William Yeung on 12/28/20.
//

import UIKit


class UpsideDownCommentView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // shadow
        let context = UIGraphicsGetCurrentContext()
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(named: "InvertedDarkMode")?.withAlphaComponent(0.09)
        shadow.shadowOffset = CGSize(width: 0, height: -5)
        shadow.shadowBlurRadius = 10
        
        let lineWidth: CGFloat = 2
        let heightMultiplier: CGFloat = 0.15
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: frame.height * heightMultiplier)) // starting point
        bezierPath.addLine(to: CGPoint(x: frame.width * 0.45, y: frame.height * heightMultiplier))
        bezierPath.addLine(to: CGPoint(x: frame.width / 2, y: (frame.height * heightMultiplier) - 15))
        bezierPath.addLine(to: CGPoint(x: frame.width * 0.55, y: frame.height * heightMultiplier))
        bezierPath.addLine(to: CGPoint(x: frame.width, y: frame.height * heightMultiplier))
        bezierPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: frame.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: frame.height * heightMultiplier - (lineWidth / 2)))
        bezierPath.close()
        
        context?.saveGState()
        context?.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        
        UIColor.clear.setStroke()
        UIColor(named: "StandardDarkMode")!.setFill()
        bezierPath.stroke()
        bezierPath.fill()
        bezierPath.lineWidth = lineWidth
        bezierPath.lineJoinStyle = .round
        bezierPath.lineCapStyle = .round
        
        context?.restoreGState()
    }
}
