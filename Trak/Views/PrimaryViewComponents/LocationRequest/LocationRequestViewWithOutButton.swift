//
//  LocationRequestViewWithButton.swift
//  TrackingApp
//
//  Created by William Yeung on 1/18/21.
//

import UIKit

class LocationRequestViewWithOutButton: BaseLocationRequestView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        permissionButton.isHidden = true
        letsGetStartedLabel.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
