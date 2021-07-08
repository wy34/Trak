//
//  WorkoutTimer.swift
//  TrackingApp
//
//  Created by William Yeung on 11/24/20.
//

import Foundation

enum TimerStatus {
    case NotStarted
    case Paused
    case Resumed
}

class ActivityTimer: NSObject {
    // MARK: - Properties
    static let shared = ActivityTimer()
    private var activeTimer: Timer?
    private var pausedTimer: Timer?
    
    var pausedTimeInSeconds: Int16 = 0
        
    var elapsedTimeInSeconds: Int16 = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.didUpdateTime, object: nil)
        }
    }
    
    var conciseFormattedTime: String {
        let seconds = elapsedTimeInSeconds % 60
        let minutes = (elapsedTimeInSeconds / 60) % 60
        let hours = elapsedTimeInSeconds / 3600
        return hours == 0 ? String(format: "%2d:%02d", minutes, seconds) : String(format: "%2d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Helpers
    private func runTimer() {
        pausedTimer?.invalidate()
        activeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            self.elapsedTimeInSeconds += 1
        })
    }
    
    func start() {
        runTimer()
    }
    
    func pause() {
        activeTimer?.invalidate()
        pausedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.pausedTimeInSeconds += 1
        })
    }
    
    func resume() {
        runTimer()
    }
    
    func invalidate() {
        elapsedTimeInSeconds = 0
        pausedTimeInSeconds = 0
        activeTimer?.invalidate()
        pausedTimer?.invalidate()
    }
}

