//
//  WorkoutHistoryVC.swift
//  TrackingApp
//
//  Created by William Yeung on 12/3/20.
//

import UIKit

class ActivityHistoryVC: UITableViewController {
    // MARK: - Properties
    var activities = [ActivitySession]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLargeNavBar(withTitle: "Distance History".localized(), andBackButtonTitle: "")
        setupTableView()
        activities = CoreDataManager.shared.fetchActivities()
        setupNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.tabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    // MARK: - Helper
    private func setupTableView() {
        tableView.register(ActivityHistoryCell.self, forCellReuseIdentifier: ActivityHistoryCell.reuseId)
        tableView.backgroundColor = UIColor.StandardDarkMode
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: .didSaveActivity, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: .didDeleteAllActivities, object: nil)
    }
    
    // MARK: - Selectors
    @objc func refreshTable() {
        activities = CoreDataManager.shared.fetchActivities()
        tableView.reloadData()
    }
}

// MARK: - UITableView Delegate/Datasource
extension ActivityHistoryVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityHistoryCell.reuseId, for: indexPath) as! ActivityHistoryCell
        cell.activitySession = activities[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let summaryVC = SummaryViewController()
        summaryVC.activityHistoryVC = self
        summaryVC.activitySession = activities[indexPath.row]
        summaryVC.alreadySaved = true
        navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete".localized()) { (action, view, completion) in
            CoreDataManager.shared.deleteActivity(activity: self.activities[indexPath.row])
            self.activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let emptyHistoryLabel = UILabel()
        emptyHistoryLabel.text = "No Activities".localized()
        emptyHistoryLabel.textAlignment = .center
        emptyHistoryLabel.textColor = .systemGray
        emptyHistoryLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)
        return emptyHistoryLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return activities.count == 0 ? 200 : 0
    }
}
