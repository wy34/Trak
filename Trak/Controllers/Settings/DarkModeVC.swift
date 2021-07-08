//
//  DarkModeVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/13/21.
//

import UIKit


class DarkModeVC: UIViewController {
    // MARK: - Properties
    private let lightDarkCellId = "cell"
    private var isAutomatic = true
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.StandardDarkMode
        tv.register(UITableViewCell.self, forCellReuseIdentifier: lightDarkCellId)
        tv.register(AutomaticDarkModeCell.self, forCellReuseIdentifier: AutomaticDarkModeCell.reuseId)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tv.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisibleSections()
        setupNotificationObservers()
        configureSmallNavBar(withTitle: "Dark Mode".localized())
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: - Helpers
    private func setupVisibleSections() {
        let displayIndex = UserDefaults.standard.integer(forKey: darkModeUDKey)
        
        switch displayIndex {
            case 0:
                break
            case 1, 2:
                isAutomatic = false
            default:
                isAutomatic = true
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showHideTableViewSection), name: Notification.Name.didSwitchAutomaticDarkMode, object: nil)
    }
    
    // MARK: - Selectors
    @objc func showHideTableViewSection() {
        isAutomatic.toggle()
        
        if isAutomatic {
            view.window?.overrideUserInterfaceStyle = .unspecified
            UserDefaults.standard.removeObject(forKey: darkModeUDKey)
        } else {
            view.window?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            UserDefaults.standard.setValue(UITraitCollection.current.userInterfaceStyle.rawValue, forKey: darkModeUDKey)
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableView Delegate/Datasource
extension DarkModeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isAutomatic && section == 1 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? UILabel.createLabel(withTitle: "Select Manually".localized(), textColor: .systemGray, font: UIFont.bold14, andAlignment: .left) : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (section: indexPath.section, row: indexPath.row) {
            case (0, 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: AutomaticDarkModeCell.reuseId, for: indexPath) as! AutomaticDarkModeCell
                cell.toggle.isOn = isAutomatic ? true : false
                cell.selectionStyle = .none
                return cell
            case (1, 0), (1, 1):
                let cell = tableView.dequeueReusableCell(withIdentifier: lightDarkCellId, for: indexPath)
                cell.textLabel?.text = indexPath.row == 0 ? "Light Mode".localized() : "Dark Mode".localized()
                cell.backgroundColor = UIColor.SettingsCellColor
                cell.textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold16!)
                cell.accessoryType = UITraitCollection.current.userInterfaceStyle == (indexPath.row == 0 ? .light : .dark) ? .checkmark : .none
                if isAutomatic { cell.isHidden  = true }
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            view.window?.overrideUserInterfaceStyle = indexPath.row == 0 ? .light : .dark
            UserDefaults.standard.setValue(traitCollection.userInterfaceStyle.rawValue, forKey: darkModeUDKey)
            tableView.reloadData()
        }
    }
}
