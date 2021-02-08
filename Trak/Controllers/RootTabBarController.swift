//
//  TabBarController.swift
//  TrackingApp
//
//  Created by William Yeung on 12/3/20.
//

import UIKit
import LocalAuthentication


class RootTabBarController: UITabBarController {
    // MARK: - Views
    lazy var settingsButton: SettingsButton = {
        let button = SettingsButton(withTitle: "Settings".localized(), andImage: "gearshape")
        button.addTarget(self, action: #selector(presentSetting), for: .touchUpInside)
        return button
    }()
    
    let mapVC = ActivityMapVC()
    let historyVC = ActivityHistoryVC()
    let launchScreenExtension = LaunchScreenExtendedView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        checkAuthentationOnOrOff()
    }
    
    override func viewDidLayoutSubviews() {
        settingsButton.frame.origin.x = view.frame.width / 3 * 2
        settingsButton.frame.origin.y = view.frame.height - settingsButton.frame.height - view.safeAreaInsets.bottom
        
        launchScreenExtension.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(launchScreenExtension)
    }
    
    // MARK: - TabBar Setup
    func setupTabBar() {
        mapVC.tabBarItem = UITabBarItem(title: "Map".localized(), image: UIImage(systemName: "map"), tag: 0)
                
        historyVC.tabBarItem = UITabBarItem(title: "History".localized(), image: UIImage(systemName: "list.bullet"), tag: 1)

        viewControllers = [mapVC, UINavigationController(rootViewController: historyVC), UIViewController()]
        tabBarController?.tabBar.isTranslucent = false
        
        setupSettingsButton()
    }
    
    func setupSettingsButton() {
        let tabBarHeight = tabBar.frame.height
        let tabBarWidth = tabBar.frame.width
        settingsButton.frame = CGRect(x: 0, y: 0, width: tabBarWidth * 0.333, height: tabBarHeight)
        view.addSubviews(settingsButton)
    }
    
    // MARK: - Authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Do you want to enable Face Id to better secure your information?") { [weak self] (success, authError) in
                DispatchQueue.main.async {
                    if success {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                            UIView.animate(withDuration: 0.3) {
                                self?.launchScreenExtension.alpha = 0
                            }
                            
                            self?.mapVC.checkLocationServices()
                        }
                    } else {
                        // when cancel is pressed
                        print("Error with authenticating")
                        self?.launchScreenExtension.unlockBtn.isHidden = false
                    }
                }
            }
        }
    }
    
    func checkAuthentationOnOrOff() {
        let auth = UserDefaults.standard.bool(forKey: authUDKey)
        
        if auth == true {
            authenticate()
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.5) {
                self.launchScreenExtension.alpha = 0
            }
            Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (_) in
                self.mapVC.checkLocationServices()
            }
        }
    }
    
    // MARK: - Selector
    @objc func presentSetting() {
        let vc = UINavigationController(rootViewController: SettingsVC())
        present(vc, animated: true, completion: nil)
    }
}






































//    private lazy var settingsBackgroundView: UIView = {
//        let view = UIView()
//        view.alpha = 0
//        view.isUserInteractionEnabled = true
//        view.backgroundColor = .clear
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//        return view
//    }()
//
//    lazy var settingsView: SettingsView = {
//        let view = SettingsView()
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:))))
//        return view
//    }()


//    // MARK: - Selectors
//    @objc func presentSetting() {
//        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
//            settingsBackgroundView.frame = keyWindow.frame
//            keyWindow.addSubview(settingsBackgroundView)
//
//            keyWindow.addSubview(settingsView)
//            settingsView.frame = CGRect(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: keyWindow.frame.height * 0.75)
//
//            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.75, options: .curveEaseIn) {
//                self.settingsBackgroundView.alpha = 1
//                self.settingsView.frame.origin.y = self.view.frame.height * 0.25
//            }
//        }
//    }
//
//    @objc func handleDismiss() {
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseOut) {
//            self.settingsBackgroundView.alpha = 0
//            self.settingsView.frame.origin.y = self.view.frame.height
//        }
//    }
//
//    @objc func handlePan(pan: UIPanGestureRecognizer) {
//        let translation = pan.translation(in: self.view)
//        let velocity = pan.velocity(in: self.view)
//        if pan.state == .began {
//            print("begin")
//        } else if pan.state == .changed && translation.y > 0 {
//            // have to add on the height of the empty space at the top
//            self.settingsView.frame.origin.y = translation.y + (self.view.frame.height * 0.25)
//        } else if pan.state == .ended {
//            UIView.animate(withDuration: 0.3) {
//                if translation.y > ((self.view.frame.height * 0.75) * 0.4) || velocity.y > 500 { // vertical drag downwards is greater than 40% of the card height or drag velocity is greater than 500
//                    self.settingsView.frame.origin.y = self.view.frame.height
//                    self.settingsBackgroundView.alpha = 0
//                } else if translation.y < ((self.view.frame.height * 0.8) * 0.4) { // vertical drag is less than 40% of the card
//                    self.settingsView.frame.origin.y = self.view.frame.height * 0.25
//                }
//            }
//        }
//    }

