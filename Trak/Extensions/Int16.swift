//
//  Int16.swift
//  TrackingApp
//
//  Created by William Yeung on 12/20/20.
//

import Foundation

extension Int16 {
    func toConciseDurationFormat() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        return hours == 0 ? String(format: "%2d:%02d", minutes, seconds) : String(format: "%2d:%02d:%02d", hours, minutes, seconds)
    }
    
    func toFullDurationFormat() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        return String(format: "%2d:%02d:%02d", hours, minutes, seconds)
    }
}
