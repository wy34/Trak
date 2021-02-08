//
//  SettingsVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/5/21.
//

import UIKit

class SettingsVC: UIViewController {
    // MARK: - Properties
    let options = [
        ["Profile".localized(), [SettingsOption(name: "", image: "person.circle", color: .orange)]],
        ["Interface".localized(), [SettingsOption(name: "Dark Mode".localized(), image: "moon.fill", color: #colorLiteral(red: 0.2783971429, green: 0.2784510851, blue: 0.2783937454, alpha: 1))]],
        ["Security".localized(), [SettingsOption(name: "Face/Touch ID".localized(), image: "faceid", color: #colorLiteral(red: 0.1905299723, green: 0.7938148379, blue: 0.6472710371, alpha: 1))]],
        ["App".localized(), [SettingsOption(name: "Language".localized(), image: "globe", color: .systemBlue), SettingsOption(name: "Clear History".localized(), image: "trash.fill", color: .systemRed)]]
    ]
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(ProfileCell.self, forCellReuseIdentifier: profileCellId)
        tv.register(BasicSettingsCell.self, forCellReuseIdentifier: basicSettingCellId)
        tv.register(AuthenciationToggleCell.self, forCellReuseIdentifier: authToggleCellId)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = UIColor(named: "StandardDarkMode")
        tv.delegate = self
        tv.dataSource = self
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tv.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureLargeNavBar(withTitle: "Settings".localized(), andBackButtonTitle: "")
        configureUI()
        // prints user defaults plist
        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        print(folder)
    }
    
    // MARK: - UI
    func configureUI() {
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    func deleteHistory() {
        if let keywindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            let blackView = UIView()
            blackView.backgroundColor = .black
            blackView.frame = keywindow.frame
            keywindow.addSubview(blackView)
            
            let label = UILabel.createLabel(withTitle: "Deleting History...".localized(), textColor: .white, font: UIFont.bold16, andAlignment: .center)
                                    
            blackView.addSubview(label)
            label.center(x: blackView.centerXAnchor, y: blackView.centerYAnchor)
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                CoreDataManager.shared.deleteAllActivities()
                NotificationCenter.default.post(name: .didDeleteAllActivities, object: nil)
                UIView.animate(withDuration: 0.3) {
                    blackView.alpha = 0
                } completion: { (_) in
                    blackView.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - TableView delegate/datasource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = options[section][0] as? String {
            let label = UILabel.createHeaderLabel(withTitle: header, andFont: UIFont.bold22)
            label.textAlignment = .left
            return label
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == options.count - 1 {
            let label = UILabel.createCaptionLabel(withTitle: "Trak, Version 1.0".localized(), withColor: .systemGray, aligned: .center)
            return label
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == options.count - 1 ? 50 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numOfRows = options[section][1] as? [SettingsOption?] else { return 0 }
        switch section {
            case 0: return 1
            case 1, 2, 3, 4: return numOfRows.count
            default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsOptionsArray = options[indexPath.section][1] as? [SettingsOption?] else { return UITableViewCell() }
        
        switch (section: indexPath.section, row: indexPath.row) {
            case (0, 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: profileCellId, for: indexPath) as! ProfileCell
                cell.settingsOption = settingsOptionsArray[indexPath.row]
                cell.accessoryType = .disclosureIndicator
                return cell
            case (1, 0), (3, 0), (3, 1):
                let cell = tableView.dequeueReusableCell(withIdentifier: basicSettingCellId, for: indexPath) as! BasicSettingsCell
                cell.settingsOption = settingsOptionsArray[indexPath.row]
                cell.accessoryType = indexPath.section == 3 && indexPath.row == 1 ? .none : .disclosureIndicator
                return cell
            case (2, 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: authToggleCellId, for: indexPath) as! AuthenciationToggleCell
                cell.settingsOption = settingsOptionsArray[indexPath.row]
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (section: indexPath.section, row: indexPath.row) {
            case (0, 0):
                let vc = ChangeProfileVC()
                navigationController?.pushViewController(vc, animated: true)
            case (1, 0):
                let vc = DarkModeVC()
                navigationController?.pushViewController(vc, animated: true)
            case (3, 0):
                let vc = LanguageVC()
                navigationController?.pushViewController(vc, animated: true)
            case (3, 1):
                let deleteAlert = UIAlertController(title: "Clear Activity History".localized(), message: "Are you sure you want to delete your activity history? This cannot be undone.".localized(), preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { (action) in
                    self.deleteHistory()
                }))
                deleteAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
                present(deleteAlert, animated: true, completion: nil)
            default:
                break
        }
    
    }
}
