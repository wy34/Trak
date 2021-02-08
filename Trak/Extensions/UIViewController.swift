//
//  UIViewController.swift
//  TrackingApp
//
//  Created by William Yeung on 1/6/21.
//

import UIKit
import UserNotifications

extension UIViewController {
    func configureLargeNavBar(withTitle title: String, andBackButtonTitle bbTitle: String) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold25!)]
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: bbTitle, style: .plain, target: nil, action: nil)
    }
    
    func configureSmallNavBar(withTitle title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)]
        navigationItem.title = title
    }
    
    func requestNotificationAuthorization(userNotifcationCenter: UNUserNotificationCenter) {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        userNotifcationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
            
            if success {
                print("Notifications Allowed")
            } else {
                print("Notifications Not Allowed")
            }
        }
    }
    
    func setupNotification(userNotifcationCenter: UNUserNotificationCenter) {
        let notificationContent = UNMutableNotificationContent()

        if let name = UserDefaults.standard.stringArray(forKey: nameUDKey) {
            notificationContent.title = "Good Morning, \(name)!"
        } else {
            notificationContent.title = "Good Morning!"
        }

        notificationContent.body = "Make sure to get out and move around a little bit today."
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = NSNumber(value: 1 + UIApplication.shared.applicationIconBadgeNumber)

        // sending reminder at 9am everyday
        let id = UUID().uuidString
        var dateComp = DateComponents()
        dateComp.hour = 9
        dateComp.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)

        userNotifcationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
