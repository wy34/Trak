//
//  ActivityTypeMenuButton.swift
//  TrackingApp
//
//  Created by William Yeung on 1/1/21.
//

import UIKit

class ActivityTypeMenuButton: UIButton {
    // MARK: - Properties
    var type: ActivityType
    
    // MARK: - Init
    init(withId id: ActivityType, andEmoji emoji: String) {
        self.type = id
        super.init(frame: .zero)
        configureUI(emojiTitle: emoji)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI(emojiTitle: String) {
        setTitle(emojiTitle, for: .normal)
        alpha = 0
        isHidden = true
        titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold15!)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
