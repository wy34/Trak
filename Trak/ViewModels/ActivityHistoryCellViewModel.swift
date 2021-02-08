//
//  WorkoutHistoryCellViewModel.swift
//  TrackingApp
//
//  Created by William Yeung on 12/19/20.
//

import Foundation

struct ActivityHistoryCellViewModel {
    var activitySession: ActivitySession
    
    init(activitySession: ActivitySession) {
        self.activitySession = activitySession
    }
    
    var fullFormattedTime: String {
        let elapsedTimeInSeconds = activitySession.duration + Int16(activitySession.pausedDuration)
        let seconds = elapsedTimeInSeconds % 60
        let minutes = (elapsedTimeInSeconds / 60) % 60
        let hours = elapsedTimeInSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var formattedDateString: String {
        guard let date = activitySession.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var formattedDistanceString: String {
        let activeDistance = (activitySession.distance * 0.000621371).roundDownToPlace(2)
        let pausedDistance = (activitySession.pausedDistance * 0.000621371).roundDownToPlace(2)
        return String(format: "%.2f mi", activeDistance + pausedDistance)
    }
    
    var typeIcon: String {
        let activityType = ActivityType(rawValue: self.activitySession.activityType ?? "")
        switch activityType {
            case .undefined:
                return "❓"
            case .walk:
                return "🚶‍♂️"
            case .run:
                return "🏃‍♂️"
            case .bike:
                return "🚴‍♂️"
            case .car:
                return "🚙"
            default:
                return ""
        }
    }
}
