//
//  SummaryViewController.swift
//  TrackingApp
//
//  Created by William Yeung on 12/6/20.
//

import UIKit
import MapKit

class SummaryViewController: UIViewController {
    // MARK: - Properties
    var routeCoordinates: [Int: [[Double]]]?
    
    var activitySession: ActivitySession? {
        didSet {
            guard let session = activitySession, let coordinatesDict = session.coordinatesDictionary else { return }
            editableTextView.text = "Add a note...".localized()
            activitySessionVM = ActivitySessionViewModel(session)
            statsArray.append(Stats(number: activitySessionVM!.formattedDistanceMilesString, unit: "MILES (active)".localized()))
            statsArray.append(Stats(number: activitySessionVM!.formattedDurationString, unit: "TIME (active)".localized()))
            statsArray.append(Stats(number: activitySessionVM!.formattedPausedDistanceMilesString, unit: "MILES (paused)".localized(), color: #colorLiteral(red: 0.6803097118, green: 0.5400025049, blue: 0.8274509804, alpha: 1)))
            statsArray.append(Stats(number: activitySessionVM!.formattedPausedDurationString, unit: "TIME (paused)".localized(), color: #colorLiteral(red: 0.6803097118, green: 0.5400025049, blue: 0.8274509804, alpha: 1)))
            navigationItem.title = activitySessionVM?.formattedDateTimeString
            iconLabel.text = activitySessionVM?.typeIcon
            routeCoordinates = coordinatesDict
            drawPolyline(withCoordinates: coordinatesDict)
        }
    }
    
    var statsArray = [Stats]()
    
    var activitySessionVM: ActivitySessionViewModel?
    var alreadySaved: Bool?
    var isPausedLocations = false
    
    var activityMapVC: ActivityMapVC?
    var showingKeyboard = false
    let shareVC = ShareViewController()
    
    var activityTypeLabelLeftAnchor: NSLayoutConstraint?
    var activityMenuLeftAnchor: NSLayoutConstraint?
    var activityMenuRightAnchor: NSLayoutConstraint?
    
    var activityHistoryVC: ActivityHistoryVC?
    
    var originalOriginY: CGFloat!
    
    var selectedActivityType: ActivityType = .undefined
    
    let noteCharacterlimit = UIScreen.main.bounds.height <= 736 ? 140 : 240
    
    let summaryCollectionViewWidth = UIScreen.main.bounds.width * 0.85
    let summaryCollectionViewHeight = UIScreen.main.bounds.height * 0.075
    
    // MARK: - Views
    var expandedSnapshotMapView: ExpandedSnapshotMapView!
    private lazy var activityTypeMenu = ActivityTypeMenu()
    
    private let moreActionsLauncher = MoreActionsLauncher()
    
    private lazy var mapSnapshotView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.isUserInteractionEnabled = false
        mv.isScrollEnabled = false
        mv.isZoomEnabled = false
        return mv
    }()
    
    private let moreInfoView = UIView.createView(withBgColor: .black, alpha: 0.5, andCornerRadius: 5)
    
    private let expandMapButton: UIButton = {
        let button = UIButton.createControlButtons(withImage: SFSymbols.expandArrows, andTintColor: .white)
        button.addTarget(self, action: #selector(expandSnapshotMap), for: .touchUpInside)
        return button
    }()
    
    private let activityTypeLabel = UILabel.createHeaderLabel(withTitle: "Activity Type:  ".localized(), andFont: UIFont.medium28)
    
    private let pausedDistanceLabelMiles = UILabel.createSummaryViewStatsLabels(withFont: nil)
    private let distanceLabelMiles = UILabel.createSummaryViewStatsLabels(withFont: nil)
    private let durationLabel = UILabel.createSummaryViewStatsLabels(withFont: nil)
    
    private let pausedMilesWordLabel = UILabel.createSummaryViewStatsLabels(withTitle: "MI (paused)", withFont: UIFont.preferredFont(forTextStyle: .caption1))
    private let milesWordLabel = UILabel.createSummaryViewStatsLabels(withTitle: "MI (active)", withFont: UIFont.preferredFont(forTextStyle: .caption1))
    private let durationWordLabel = UILabel.createSummaryViewStatsLabels(withTitle: "DURATION", withFont: UIFont.preferredFont(forTextStyle: .caption1))

    private let summaryStackBackgroundView = UIView.createView(withBgColor: UIColor.DarkModeGray, alpha: 1, andCornerRadius: 0)
    
    private lazy var numbersStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pausedDistanceLabelMiles, distanceLabelMiles, durationLabel])
        stack.distribution = .fillEqually
        stack.spacing = 1
        return stack
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pausedMilesWordLabel, milesWordLabel, durationWordLabel])
        stack.distribution = .fillEqually
        stack.spacing = 1
        return stack
    }()
    
    private lazy var summaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(StatsCell.self, forCellWithReuseIdentifier: StatsCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.isScrollEnabled = false
        cv.backgroundColor = .systemGray6
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let scrollLeftBtn = UIButton.createScrollButtons(withImage: SFSymbols.triangleLeft, andTag: 1)
    private let scrollRightBtn = UIButton.createScrollButtons(withImage: SFSymbols.triangleRight, andTag: 2)
    
    private let saveBtn: UIButton = {
        let button = UIButton.createSummaryViewMainButtons(withTitle: "SAVE ACTIVITY".localized(), bgColor: .systemGreen, andFont: UIFont.bold17)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    private let shareBtn: UIButton = {
        let button = UIButton.createSummaryViewMainButtons(withTitle: "SHARE".localized(), bgColor: #colorLiteral(red: 0.2027813196, green: 0.5947964191, blue: 0.7698691487, alpha: 1), andFont: UIFont.bold17)
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let deleteBtn: UIButton = {
        let button = UIButton.createSummaryViewMainButtons(withTitle: "DELETE ACTIVITY".localized(), bgColor: .clear, andFont: UIFont.bold11)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteActivity), for: .touchUpInside)
        return button
    }()

    private lazy var btnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deleteBtn, saveBtn, shareBtn])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = -2.5
        return stack
    }()
    
    private lazy var uneditableTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 5
        tv.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium15!)
        tv.isEditable = false
        tv.isHidden = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var editableTextView: UITextView = {
        let tv = TextViewWithImage()
        tv.text = "Add a note...".localized()
        tv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2524614726)
        tv.layer.cornerRadius = 5
        tv.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium15!)
        tv.leftImage = SFSymbols.pencil
        tv.delegate = self
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold15!)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let characterCountLabel = UILabel.createLabel(withTitle: "", textColor: .systemGray, font: UIFont.light10, andAlignment: .right)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutViews()
        setupSwipeGesture()
        setupButtonTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    // MARK: - Helpers
    private func configureUI() {
        checkIfAlreadySaved()
        edgesForExtendedLayout = []
        view.backgroundColor = .systemGray6
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium16!)]
        characterCountLabel.text = "Characters left: ".localized() + "\(noteCharacterlimit)"
    }
    
    private func layoutViews() {
        view.addSubviews(mapSnapshotView, activityTypeLabel, activityTypeMenu, iconLabel, summaryCollectionView, uneditableTextView, editableTextView, btnStack, characterCountLabel, moreInfoView, scrollLeftBtn, scrollRightBtn)
        
        mapSnapshotView.setDimension(height: view.heightAnchor, hMult: 0.35)
        mapSnapshotView.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor)
        
        activityTypeLabel.anchor(top: mapSnapshotView.bottomAnchor, paddingTop: 12)
        activityTypeLabelLeftAnchor = activityTypeLabel.leftAnchor.constraint(equalTo: mapSnapshotView.leftAnchor, constant: 20)
        activityTypeLabelLeftAnchor?.isActive = true
        activityTypeLabel.setDimension(hConst: UIScreen.main.bounds.height * 0.06)
        
        iconLabel.center(to: activityTypeLabel, by: .centerY)
        iconLabel.setDimension(wConst: 40, hConst: 40)
        iconLabel.anchor(left: activityTypeLabel.rightAnchor)
        
        activityTypeMenu.delegate = self
        activityTypeMenu.center(to: activityTypeLabel, by: .centerY)
        activityTypeMenu.setDimension(width: iconLabel.widthAnchor, height: iconLabel.heightAnchor)
        activityMenuRightAnchor = activityTypeMenu.rightAnchor.constraint(equalTo: mapSnapshotView.rightAnchor, constant: -20)
        activityMenuLeftAnchor = activityTypeMenu.leftAnchor.constraint(equalTo: activityTypeLabel.rightAnchor)
        activityMenuLeftAnchor?.isActive = true
        
        summaryCollectionView.anchor(top: activityTypeLabel.bottomAnchor, paddingTop: 12)
        summaryCollectionView.center(to: view, by: .centerX, withMultiplierOf: 1.015)
        summaryCollectionView.setDimension(wConst: summaryCollectionViewWidth, hConst: summaryCollectionViewHeight)
        
        scrollLeftBtn.center(to: summaryCollectionView, by: .centerY)
        scrollLeftBtn.anchor(left: view.leftAnchor, paddingLeft: 20)
        scrollLeftBtn.setDimension(wConst: 15, hConst: 15)
        
        scrollRightBtn.center(to: summaryCollectionView, by: .centerY)
        scrollRightBtn.anchor(right: view.rightAnchor, paddingRight: 20)
        scrollRightBtn.setDimension(wConst: 15, hConst: 15)
        
        uneditableTextView.anchor(top: summaryCollectionView.bottomAnchor, right: view.rightAnchor, left: view.leftAnchor, paddingTop: 15, paddingRight: 20, paddingLeft: 20)
        editableTextView.anchor(top: uneditableTextView.topAnchor, right: uneditableTextView.rightAnchor, left: uneditableTextView.leftAnchor)
        
        characterCountLabel.anchor(top: editableTextView.bottomAnchor, right: editableTextView.rightAnchor, paddingTop: 3)

        btnStack.anchor(right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, paddingRight: 20, paddingBottom: 12, paddingLeft: 20)
        btnStack.setDimension(hConst: 65)

        moreInfoView.setDimension(width: mapSnapshotView.widthAnchor, height: mapSnapshotView.widthAnchor, wMult: 0.1, hMult: 0.1)
        moreInfoView.anchor(right: mapSnapshotView.rightAnchor, bottom: mapSnapshotView.bottomAnchor)

        moreInfoView.addSubview(expandMapButton)
        expandMapButton.center(x: moreInfoView.centerXAnchor, y: moreInfoView.centerYAnchor)
    }
    
    private func checkIfAlreadySaved() {
        if let alreadySaved = alreadySaved {
            if alreadySaved {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: self, action:  #selector(handleMoreButton))
                uneditableTextView.text = activitySession?.activityNote
                uneditableTextView.isHidden = false
                editableTextView.isHidden = true
                
                characterCountLabel.isHidden = true
                saveBtn.isHidden = true
                shareBtn.isHidden = false
                deleteBtn.alpha = 0
                activityTypeMenu.isHidden = true
                iconLabel.isHidden = false
            }
        }
    }
    
    private func setupSwipeGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleKeyboardDismiss))
        swipe.direction = .down
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismiss))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
        swipe.delegate = self
    }
    
    private func drawPolyline(withCoordinates coordinates: [Int: [[Double]]]) {
        let coordinatesArray = mapSnapshotView.convertCoordinateDictionaryToCoordinateArrays(coordinates: coordinates)

        // drawing on polylines
        for i in 0..<coordinatesArray.count {
            isPausedLocations = i % 2 == 0 ? false : true
            let polyline = MKPolyline(coordinates: coordinatesArray[i], count: coordinatesArray[i].count)
            mapSnapshotView.addOverlay(polyline)
        }
        
        mapSnapshotView.addStartEndAnnotations(coordinates: coordinatesArray)
    }
    
    private func setupButtonTargets() {
        scrollLeftBtn.addTarget(self, action: #selector(scrollStats(sender:)), for: .touchUpInside)
        scrollRightBtn.addTarget(self, action: #selector(scrollStats(sender:)), for: .touchUpInside)
    }
    
    private func discardAlert() {
        let alertTitle = "Do you want to delete this activity? This cannot be undone."
        let alert = UIAlertController(title: "Delete Activity".localized(), message: alertTitle.localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { (_) in
            self.discardActivity()
        }))
        alert.addAction(UIAlertAction(title: "No".localized(), style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func discardActivity() {
        guard let activitySession = self.activitySession else { return }
        if let alreadySaved = self.alreadySaved {
            if alreadySaved {
                self.navigationController?.popViewController(animated: true)
                if let index = self.activityHistoryVC?.activities.firstIndex(where: { $0.id == self.activitySession?.id }) {
                    self.activityHistoryVC?.activities.remove(at: index)
                    self.activityHistoryVC?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            CoreDataManager.shared.deleteActivity(activity: activitySession)
        }
    }
    
    private func updateHistoryCountBadge() {
        UIApplication.tabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New".localized()
    }
    
    func showViewForAction(action: Action) {
        switch action {
        case .Share:
            goToShareVC()
        case .Edit:
            setupEditPhase()
        case .Delete:
            dismissKeyboard()
            discardAlert()
        case .Cancel:
            break
        }
    }
    
    private func setupEditPhase() {
        guard let activitySession = self.activitySession else { debugPrint("workout session"); return }
        guard let note = activitySession.activityNote else { debugPrint("workout note"); return }
        guard let type = activitySession.activityType else { debugPrint("type"); return }
        navigationItem.title = "Edit Mode".localized()
        
        let cancelEdit = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(self.handleCancelEdit))
        let textAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium17!)]
        cancelEdit.tintColor = .systemRed
        cancelEdit.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.rightBarButtonItem = cancelEdit
        
        editableTextView.text = note
        if editableTextView.text == "No Note" {
            characterCountLabel.text = "Characters left: ".localized() +  "\(noteCharacterlimit)"
        } else {
            characterCountLabel.text = "Characters left: ".localized() + String((noteCharacterlimit - editableTextView.text.count))
        }
        
        uneditableTextView.isHidden = true
        editableTextView.isHidden = false
        iconLabel.isHidden = true
        activityTypeMenu.setSelectedButton(forType: type)
        selectedActivityType = ActivityType(rawValue: type)!
        activityTypeMenu.isHidden = false
        saveBtn.isHidden = false
        shareBtn.isHidden = true
        characterCountLabel.isHidden = false
    }
    
    private func goToShareVC() {
        shareVC.activitySession = self.activitySession
        let navController = UINavigationController(rootViewController: shareVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func saveActivity() {
        guard let alreadySaved = alreadySaved else { return }
        guard let note = editableTextView.text else { return }
        guard let activitySession = self.activitySession else { return }
        
        if alreadySaved {
            navigationItem.title = activitySessionVM?.formattedDateTimeString
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: self, action:  #selector(handleMoreButton))
            activitySession.activityNote = note == "" ? "No Note" : note
            uneditableTextView.text = activitySession.activityNote
            dismissKeyboard()
            uneditableTextView.isHidden = false
            editableTextView.isHidden = true
            activitySession.activityType = self.selectedActivityType.rawValue
            CoreDataManager.shared.save()
            activitySessionVM = ActivitySessionViewModel(activitySession)
            iconLabel.text = activitySessionVM?.typeIcon
            activityHistoryVC?.tableView.reloadData()
            activityTypeMenu.isHidden = true
            iconLabel.isHidden = false
            saveBtn.isHidden = true
            shareBtn.isHidden = false
            characterCountLabel.isHidden = true
        } else {
            activitySession.activityType = selectedActivityType.rawValue
            activitySession.activityNote = note == "Add a note...".localized() ? "No Note".localized() : note
            CoreDataManager.shared.save()
            updateHistoryCountBadge()
            NotificationCenter.default.post(name: .didSaveActivity, object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func dismissKeyboard() {
        if showingKeyboard == true {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = self.originalOriginY
                self.view.layoutIfNeeded()
            }
            editableTextView.endEditing(true)
            showingKeyboard = false
        }
    }

    // MARK: - Selectors
    @objc func scrollStats(sender: UIButton) {
        summaryCollectionView.setContentOffset(CGPoint(x: (CGFloat(sender.tag - 1) * (summaryCollectionViewWidth)), y: 0), animated: true)
        scrollLeftBtn.isHidden = sender.tag == 1 ? true : false
        scrollRightBtn.isHidden = sender.tag == 2 ? true : false
    }
    
    @objc func handleMoreButton() {
        moreActionsLauncher.summaryVC = self
        moreActionsLauncher.showMoreActionsMenu()
    }
    
    @objc func handleCancelEdit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.ellipsis, style: .plain, target: self, action:  #selector(handleMoreButton))
        uneditableTextView.text = activitySession?.activityNote
        uneditableTextView.isHidden = false
        editableTextView.isHidden = true
        
        saveBtn.isHidden = true
        shareBtn.isHidden = false
        deleteBtn.alpha = 0
        
        activityTypeMenu.isHidden = true
        iconLabel.isHidden = false
        characterCountLabel.isHidden = true
        
        navigationItem.title = activitySessionVM?.formattedDateTimeString
        dismissKeyboard()
        
        if let constant = activityTypeLabelLeftAnchor?.constant, ...0 ~= constant {
            closeMenu(withTypeSelection: nil)
            activityTypeMenu.resetMenuToDefault()
        }
    }
    
    @objc func handleShare() {
        goToShareVC()
    }
    
    @objc func handleSave() {
        saveActivity()
    }
    
    @objc func deleteActivity() {
        dismissKeyboard()
        discardAlert()
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        if showingKeyboard == false {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = keyboardFrame.cgRectValue.height
                originalOriginY = view.frame.origin.y
                guard let alreadySaved = self.alreadySaved else { return }
                view.frame.origin.y = alreadySaved ? -height * 0.53 : -height * 0.72
                showingKeyboard = true
            }
        }
    }
    
    @objc func handleKeyboardDismiss() {
        dismissKeyboard()
    }
    
    @objc func expandSnapshotMap() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            expandedSnapshotMapView = ExpandedSnapshotMapView()
            expandedSnapshotMapView.routeCoordinates = self.routeCoordinates
            expandedSnapshotMapView.alpha = 0
            expandedSnapshotMapView.delegate = self
            expandedSnapshotMapView.frame = keyWindow.frame
            keyWindow.addSubview(expandedSnapshotMapView)
            UIView.animate(withDuration: 0.3) {
                self.expandedSnapshotMapView.alpha = 1
            }
        }
    }
}

// MARK: - UICollectionView delegate
extension SummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatsCell.reuseId, for: indexPath) as! StatsCell
        if indexPath.item % 2 != 0 {
            cell.addLeftCellBorder(withColor: UIColor.DarkModeGray, width: 1, height: 25)
        }
        cell.stats = statsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: summaryCollectionViewWidth / 2, height: summaryCollectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
}

// MARK: - MapView Delegate
extension SummaryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = isPausedLocations ? .systemPurple : .systemBlue
        renderer.lineWidth = 3
        return renderer
    }
}

// MARK: - UITextView
extension SummaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add a note...".localized() || textView.text == "No Note".localized() {
            editableTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if let alreadySaved = alreadySaved {
                if alreadySaved {
                    editableTextView.text = "No Note".localized()
                } else {
                    editableTextView.text = "Add a note...".localized()
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        if updatedText.count <= noteCharacterlimit {
            characterCountLabel.text = "Characters left: ".localized() + String(noteCharacterlimit - updatedText.count)
        }
        return updatedText.count <= noteCharacterlimit
    }
}

// MARK: - ExpandedSnapshotMapViewDelegate
extension SummaryViewController: ExpandedSnapshotMapViewDelegate {
    func dismissView() {
        UIView.animate(withDuration: 0.3) {
            self.expandedSnapshotMapView.alpha = 0
        } completion: { (_) in
            self.expandedSnapshotMapView.removeFromSuperview()
        }
    }
}

// MARK: - ActivityTypeMenuDelegate
extension SummaryViewController: ActivityTypeMenuDelegate {
    func handleMenu(isOpen: Bool, withType type: ActivityType) {
        if isOpen == true {
            openMenu()
        } else {
            closeMenu(withTypeSelection: type)
        }
    }
    
    func openMenu() {
        UIView.animate(withDuration: 0.3) {
            self.activityTypeLabel.alpha = 0
            self.activityTypeLabelLeftAnchor?.constant = -225
            self.activityMenuRightAnchor?.isActive = true
            self.activityMenuLeftAnchor = self.activityTypeMenu.leftAnchor.constraint(equalTo: self.mapSnapshotView.leftAnchor, constant: 20)
            self.activityMenuLeftAnchor?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func closeMenu(withTypeSelection type: ActivityType?) {
        UIView.animate(withDuration: 0.3) {
            if let type = type {
                self.selectedActivityType = type
            }
            
            self.activityTypeLabel.alpha = 1
            self.activityMenuRightAnchor?.isActive = false
            self.activityMenuLeftAnchor?.isActive = false
            self.activityTypeLabelLeftAnchor?.constant = 20
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Gesture Recognizer
extension SummaryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
