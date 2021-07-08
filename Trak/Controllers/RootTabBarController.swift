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
    
    // MARK: - Helpers
    private func setupTabBar() {
        mapVC.tabBarItem = UITabBarItem(title: "Map".localized(), image: SFSymbols.map, tag: 0)
                
        historyVC.tabBarItem = UITabBarItem(title: "History".localized(), image: SFSymbols.bulletList, tag: 1)

        viewControllers = [mapVC, UINavigationController(rootViewController: historyVC), UIViewController()]
        tabBarController?.tabBar.isTranslucent = false
        
        setupSettingsButton()
    }
    
    private func setupSettingsButton() {
        let tabBarHeight = tabBar.frame.height
        let tabBarWidth = tabBar.frame.width
        settingsButton.frame = CGRect(x: 0, y: 0, width: tabBarWidth * 0.333, height: tabBarHeight)
        view.addSubviews(settingsButton)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let localizedReason = "Do you want to enable Face Id to better secure your information?"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason) { [weak self] (success, authError) in
                DispatchQueue.main.async {
                    if success {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                            UIView.animate(withDuration: 0.3) {
                                self?.launchScreenExtension.alpha = 0
                            }
                            
                            self?.mapVC.checkLocationServices()
                        }
                    } else {
                        debugPrint("Error with authenticating")
                        self?.launchScreenExtension.unlockBtn.isHidden = false
                    }
                }
            }
        }
    }
    
    private func checkAuthentationOnOrOff() {
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
