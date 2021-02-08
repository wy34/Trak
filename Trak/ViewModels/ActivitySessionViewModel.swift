//
//  WorkoutSessionViewModel.swift
//  TrackingApp
//
//  Created by William Yeung on 12/9/20.
//

import UIKit

struct ActivitySessionViewModel {
    var isShareScreen: Bool
    var activitySession: ActivitySession
    
    init(_ activitySession: ActivitySession, isShareScreen: Bool = false) {
        self.activitySession = activitySession
        self.isShareScreen = isShareScreen
    }
    
    func conciseDurationForTime(duration: Int16) -> String {
        let elapsedTimeInSeconds = duration
        let seconds = elapsedTimeInSeconds % 60
        let minutes = (elapsedTimeInSeconds / 60) % 60
        let hours = elapsedTimeInSeconds / 3600
        return hours == 0 ? String(format: "%2d:%02d", minutes, seconds) : String(format: "%2d:%02d:%02d", hours, minutes, seconds)
    }
    
    var formattedDateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let formattedDate = formatter.string(from: activitySession.date!)
        formatter.dateFormat = "h:mm a"
        let formattedTime = formatter.string(from: activitySession.date!)
        return "\(formattedDate) at \(formattedTime)"
    }
    
    var formattedDurationString: NSAttributedString {
        var attributedText: NSAttributedString
        let formattedDuration = conciseDurationForTime(duration: activitySession.duration)
        
        if !isShareScreen {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
        
        return attributedText
    }
    
    var formattedPausedDistanceMilesString: NSAttributedString {
        var attributedText: NSAttributedString
        let distance = (activitySession.pausedDistance * 0.000621371).roundDownToPlace(2)
         
        if !isShareScreen {
            attributedText = NSAttributedString(string: String(format: "%.2f", distance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: String(format: "%.2f", distance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
       
        return attributedText
    }
    
    var formattedPausedDurationString: NSAttributedString {
        var attributedText: NSAttributedString
        let formattedDuration = conciseDurationForTime(duration: activitySession.pausedDuration)

        
        if !isShareScreen {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
        
        return attributedText
    }
    
    var formattedDistanceMilesString: NSAttributedString {
        var attributedText: NSAttributedString
        let distance = (activitySession.distance * 0.000621371).roundDownToPlace(2)
        
        if !isShareScreen {
            attributedText = NSAttributedString(string: String(format: "%.2f", distance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: String(format: "%.2f", distance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
        
        return attributedText
    }
    
    var formattedTotalDistanceMilesString: NSAttributedString {
        var attributedText: NSAttributedString
        let totalDistance = (activitySession.pausedDistance * 0.000621371).roundDownToPlace(2) + (activitySession.distance * 0.000621371).roundDownToPlace(2)
         
        if !isShareScreen {
            attributedText = NSAttributedString(string: String(format: "%.2f", totalDistance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: String(format: "%.2f", totalDistance), attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
       
        return attributedText
    }
    
    var formattedTotalDurationString: NSAttributedString {
        var attributedText: NSAttributedString
        let formattedDuration = conciseDurationForTime(duration: activitySession.pausedDuration + activitySession.duration)

        
        if !isShareScreen {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold17!)])
        } else {
            attributedText = NSAttributedString(string: "\(formattedDuration)", attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!), NSAttributedString.Key.foregroundColor: UIColor.white.cgColor])
        }
        
        return attributedText
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
