//
//  StatsCell.swift
//  TrackingApp
//
//  Created by William Yeung on 1/19/21.
//

import UIKit

class StatsCell: UICollectionViewCell {
    // MARK: - Properties
    var stats: Stats? {
        didSet {
            guard let stats = stats else { return }
            numberLabel.attributedText = stats.number
            unitLabel.text = stats.unit
            numberLabel.textColor = stats.color
            unitLabel.textColor = stats.color
        }
    }
    
    static let reuseId = "StatsCell"
    
    // MARK: - Views
    private let numberLabel = UILabel.createLabel(withTitle: "", textColor: nil, font: nil, andAlignment: .center)
    private let unitLabel = UILabel.createLabel(withTitle: "Active Miles", textColor: nil, font: UIFont.medium11, andAlignment: .center)
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberLabel, unitLabel])
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(stack)
        
        stack.center(to: self, by: .centerX)
        stack.center(to: self, by: .centerY)
    }
}
