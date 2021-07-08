//
//  ActivityHistoryCell.swift
//  TrackingApp
//
//  Created by William Yeung on 12/3/20.
//

import UIKit

class ActivityHistoryCell: UITableViewCell {
    // MARK: - Properties
    var activitySession: ActivitySession? {
        didSet {
            guard let activitySession = activitySession else { return }
            let activityHistoryCellVM = ActivityHistoryCellViewModel(activitySession: activitySession)
            dateLabel.text = activityHistoryCellVM.formattedDateString
            distanceLabel.text = activityHistoryCellVM.formattedDistanceString
            durationLabel.text = activityHistoryCellVM.fullFormattedTime
            activityTypeIcon.text = activityHistoryCellVM.typeIcon
        }
    }
    
    static let reuseId = "WorkoutHistoryCell"
    
    // MARK: - Views
    private let activityTypeIcon = UILabel()
    
    private let distanceLabel = UILabel.createLabel(withTitle: "", textColor: nil, font: UIFont.bold16)
    
    private let durationLabel = UILabel.createLabel(withTitle: "", textColor: .systemGray3, font: UIFont.medium12)
    
    private lazy var distanceDurationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [distanceLabel, durationLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let dateLabel = UILabel.createLabel(withTitle: "", textColor: nil, font: UIFont.bold13)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = UIColor.StandardDarkMode
        activityTypeIcon.tintColor = UIColor.InvertedDarkMode
    }
    
    private func layoutUI() {
        addSubviews(activityTypeIcon, distanceDurationStack, dateLabel)
        
        activityTypeIcon.setDimension(wConst: 30, hConst: 30)
        activityTypeIcon.center(to: self, by: .centerY)
        activityTypeIcon.anchor(left: leftAnchor, paddingLeft: 25)
        
        distanceDurationStack.center(to: activityTypeIcon, by: .centerY)
        distanceDurationStack.setDimension(width: widthAnchor, wMult: 0.5)
        distanceDurationStack.anchor(left: activityTypeIcon.rightAnchor, paddingLeft: 20)
        
        dateLabel.center(to: activityTypeIcon, by: .centerY)
        dateLabel.anchor(right: rightAnchor, paddingRight: 35)
    }
}
