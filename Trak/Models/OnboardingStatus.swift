//
//  Onboarding.swift
//  TrackingApp
//
//  Created by William Yeung on 1/5/21.
//

import UIKit

class OnboardingStatus {
    static let shared = OnboardingStatus()

    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: onboardingUDKey)
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.setValue(true, forKey: onboardingUDKey)
    }
}
