//
//  Notification.Name.swift
//  TrackingApp
//
//  Created by William Yeung on 12/9/20.
//

import UIKit

extension Notification.Name {
    static var didUpdateTime = Notification.Name("didUpdateTime")
    static var didChangeDistance = Notification.Name("didChangeDistance")
    static var musicPlayerStartStopPlaying = Notification.Name("MainVC.musicPlayerStartPlaying")
    static var didBeginEditing = Notification.Name("didBeginEditing")
    static var didEndEditing = Notification.Name("didEndEditing")
    static var didPressFinish = Notification.Name("didPressFinish")
    static var didSaveActivity = Notification.Name("didSaveActivity")
    static var didDeleteAllActivities = Notification.Name("didDeleteAllActivities")
    static var didSwitchAutomaticDarkMode = Notification.Name("didSwitchAutomaticDarkMode")
    static var didChangeName = Notification.Name("didChangeName")
    static var didChangeImage = Notification.Name("didChangeImage")
}
