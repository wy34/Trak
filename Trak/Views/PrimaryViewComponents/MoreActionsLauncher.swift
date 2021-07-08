//
//  SettingsLauncher.swift
//  TrackingApp
//
//  Created by William Yeung on 1/6/21.
//

import UIKit


class MoreActionsLauncher: NSObject {
    // MARK: - Properties
    let cellHeight: CGFloat = 50
    private let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    
    var summaryVC: SummaryViewController? = nil
    var changeProfileVC: ChangeProfileVC? = nil
    
    var moreActions = [
        Option(title: Action.Share, image: "square.and.arrow.up"),
        Option(title: Action.Edit, image: "pencil.circle"),
        Option(title: Action.Delete, image: "trash"),
        Option(title: Action.Cancel, image: "xmark.circle")
    ]
    
    var cameraActions = [
        Option(title: UIImagePickerController.SourceType.photoLibrary, image: "photo"),
        Option(title: UIImagePickerController.SourceType.camera, image: "camera")
    ]
    
    // MARK: - Views
    private lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.MenuDarkMode.withAlphaComponent(0.75)
        tv.register(OptionCell.self, forCellReuseIdentifier: OptionCell.reuseId)
        tv.isScrollEnabled = false
        tv.separatorColor = UIColor.InvertedDarkMode.withAlphaComponent(0.15)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.layer.cornerRadius = 20
        return tv
    }()
    
    // MARK: - Init
     override init() {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Helpers
    func showMoreActionsMenu() {
        if let window = window {
            window.addSubview(blackView)
            blackView.frame = window.frame
            
            window.addSubview(tableView)
            let height: CGFloat = CGFloat(summaryVC != nil ? moreActions.count : cameraActions.count) * cellHeight + 30
            let y = window.frame.height - (25 + height)
            tableView.frame = CGRect(x: 15, y: window.frame.height, width: window.frame.width - 30, height: height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.blackView.alpha = 1
                self.tableView.frame.origin.y = y
            }
        }
    }
    
    private func handleCompletion(atIndexPath indexPath: IndexPath) {
        if let _ = summaryVC {
            let action = moreActions[indexPath.row]
            if action.title != .Cancel {
                guard let summaryVC = self.summaryVC else { return }
                summaryVC.showViewForAction(action: action.title)
            }
        } else {
            let action = cameraActions[indexPath.row]
            guard let changeProfileVC = changeProfileVC else { return }
            changeProfileVC.showViewForAction(action: action.title)
        }
    }
    
    // MARK: - Selectors
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = self.window {
                self.tableView.frame.origin.y = window.frame.height
            }
        }
    }
}

// MARK: - UITableView Delegate/Datasource
extension MoreActionsLauncher: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.createHeaderLabel(withTitle: summaryVC != nil ? "Activity Options".localized() : "Camera Options".localized(), andFont: UIFont.bold12)
        label.addBorder(toSide: .bottom, withColor: UIColor.InvertedDarkMode.withAlphaComponent(0.05), andDimension: 1.5)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryVC != nil ? moreActions.count : cameraActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.reuseId, for: indexPath) as! OptionCell
        
        if let _ = summaryVC {
            cell.moreAction = moreActions[indexPath.row]
        } else {
            cell.camerAction = cameraActions[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.blackView.alpha = 0
            if let window = self.window {
                self.tableView.frame.origin.y = window.frame.height
            }
        } completion: { (success) in
            self.handleCompletion(atIndexPath: indexPath)
        }
    }
}



