//
//  ActivityMapVC.swift
//  TrackingApp
//
//  Created by William Yeung on 11/20/20.
//

import UIKit
import MapKit
import CoreLocation
import MediaPlayer

class ActivityMapVC: UIViewController {
    // MARK: - Properties
    var locationManager: CLLocationManager!
    
    var activeLocations = [CLLocationCoordinate2D]()
    var pausedLocations = [CLLocationCoordinate2D]()
    
    var allLocations = [Int: [[Double]]]()
    var dictionaryId = 0
    
    var activeDistanceParts = [CLLocationDistance]()
    var totalActiveDistance: CLLocationDistance = 0
    
    var pausedDistanceParts = [CLLocationDistance]()
    var totalPausedDistance: CLLocationDistance = 0
    
    var statsViewHeightAnchor: NSLayoutConstraint!
    
    var mapAnnotation: MapAnnotation?
    var centerUserLocation = true
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        
    var timerStatus: TimerStatus = .NotStarted
    
    var isMusicPlayerShowing = false
    
    // MARK: - Views
    private let statsView = TimerDistanceView()
    private let loadView = LoadView()
    private let requestView = BaseLocationRequestView()
    private let topBlueBorderLine = UIView.createBlueBorderLine()
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.userTrackingMode = .follow
        mv.showsCompass = false
        mv.mapType = .standard
        return mv
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton.createMapButtons(withImage: "")
        button.addTarget(self, action: #selector(goBackToUserLocation), for: .touchUpInside)
        return button
    }()
    
    private let musicLibraryButton: UIButton = {
        let button = UIButton.createMapButtons(withImage: "list.bullet")
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 14))
        button.setImage(UIImage(systemName: "list.bullet", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(openMusicLibrary), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private let musicPlayerButton: UIButton = {
        let button = UIButton.createMapButtons(withImage: "music.note")
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 14))
        button.setImage(UIImage(systemName: "music.note", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(showSlideOutView), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private lazy var slideOutView: SlideOutMusicView = {
        let view = SlideOutMusicView()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didSlideView)))
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupMapDragGesture()
        musicPlayer.prepareToPlay()
        musicPlayer.setQueue(with: .songs())
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let locationManager = self.locationManager else { return }
        self.locationManager = locationManager
    }
    
    // MARK: - UI
    func configureUI() {
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor(named: "StandardDarkMode")
        updateLocationButtonImage(to: "location")
        layoutViews()
        statsView.delegate = self
    }
    
    func layoutViews() {
        view.addSubviews(topBlueBorderLine, mapView, locationButton, musicPlayerButton, musicLibraryButton, slideOutView, statsView, loadView)
        
        topBlueBorderLine.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, left: view.leftAnchor)
        topBlueBorderLine.setDimension(hConst: 3)
        
        statsViewHeightAnchor = statsView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.2)
        statsViewHeightAnchor.isActive = true
        statsView.anchor(right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        
        mapView.anchor(top: topBlueBorderLine.bottomAnchor, right: view.rightAnchor, bottom: statsView.topAnchor, left: view.leftAnchor, paddingTop: 1)
        
        locationButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.1, hMult: 0.1)
        locationButton.anchor(top: mapView.topAnchor, right: view.rightAnchor, paddingTop: 45, paddingRight: 10)
        
        musicPlayerButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.1, hMult: 0.1)
        musicPlayerButton.anchor(top: locationButton.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 10)
        
        musicLibraryButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.1, hMult: 0.1)
        musicLibraryButton.anchor(top: musicPlayerButton.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 10)
        
        slideOutView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: statsView.topAnchor, left: view.leftAnchor, paddingLeft: -UIScreen.main.bounds.width * 0.8)
        slideOutView.setDimension(wConst: UIScreen.main.bounds.width * 0.80)
        
        loadView.anchor(top: topBlueBorderLine.topAnchor, right: view.rightAnchor, bottom: mapView.bottomAnchor, left: view.leftAnchor)
        loadView.alpha = 0
    }
    
    // MARK: - Location/Map
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            checkAuthStatus()
        }
    }
    
    func checkAuthStatus() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                presentOnboardingOrPermission()
            case .restricted:
                break
            case .denied:
                disableButtons()
            case .authorizedAlways:
                break
            case .authorizedWhenInUse:
                showUserLocation()
            @unknown default:
                break
        }
    }
    
    func presentOnboardingOrPermission() {
        if OnboardingStatus.shared.isNewUser() {
            let onboarding = OnboardingVC()
            onboarding.activityMapVC = self
            onboarding.modalPresentationStyle = .fullScreen
            onboarding.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(onboarding, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.requestView.alpha = 0
                if let keywindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                    self.requestView.locationReqestDelegate = self
                    self.requestView.locationManager = self.locationManager
                    self.requestView.frame = keywindow.frame
                    keywindow.addSubview(self.requestView)
                }
                UIView.animate(withDuration: 0.5) {
                    self.requestView.alpha = 1
                }
            }
        }
    }
    
    func showUserLocation() {
        statsView.buttonStack.isUserInteractionEnabled = true
        mapView.showsUserLocation = true
        zoomAndCenterUserLocation()
    }
    
    func updateLocationButtonImage(to image: String) {
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 12))
        locationButton.setImage(UIImage(systemName: image, withConfiguration: imageConfig), for: .normal)
    }
    
    func zoomAndCenterUserLocation() {
        guard let userLocation =  locationManager?.location else { return }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        updateLocationButtonImage(to: "location.fill")
    }
    
    func disableButtons() {
        locationButton.isEnabled = false
        statsView.buttonStack.isUserInteractionEnabled = false
        let alert = UIAlertController(title: "Location Service Disabled", message: "If you want to track your activities, please go to Settings > Trak > Location and allow track to use your location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true)
    }
    
    func setupMapDragGesture() {
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
        mapDragRecognizer.delegate = self
        self.mapView.addGestureRecognizer(mapDragRecognizer)
    }
    
    func addPolyline(at coordinate: CLLocationCoordinate2D) {
        if timerStatus != .Paused {
            self.activeLocations.append(coordinate)
        } else {
            self.pausedLocations.append(coordinate)
        }
        
        let locationSet = timerStatus != .Paused ? self.activeLocations : self.pausedLocations
        let polyline = MKPolyline(coordinates: locationSet, count: locationSet.count)
        self.mapView.addOverlay(polyline)
    }
    
    func calculateDistance(toLatestLocation latestLocation: CLLocation) -> CLLocationDistance {
        if activeLocations.count >= 2 {
            let prevCoordinate = self.activeLocations[self.activeLocations.count - 2]
            let prevLocation = CLLocation(latitude: prevCoordinate.latitude, longitude: prevCoordinate.longitude)
            let distanceInMeters = prevLocation.distance(from: latestLocation)
            activeDistanceParts.append(distanceInMeters)
            return activeDistanceParts.reduce(0) { $0 + $1 }
        }
        
        return 0
    }
    
    func convertViewToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(mapView.frame.size, mapView.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func takeSnapshot() {
        guard let snapshotWithOverlays = convertViewToImage() else { return }
        let activitySession = CoreDataManager.shared.createActivity(withSnapshot: snapshotWithOverlays, duration: ActivityTimer.shared.elapsedTimeInSeconds, pausedDuration: ActivityTimer.shared.pausedTimeInSeconds, distance: self.totalActiveDistance, pausedDistance: totalPausedDistance, coordinates: allLocations)
        let summaryView = SummaryViewController()
        summaryView.activitySession = activitySession
        summaryView.alreadySaved = false
        let navController = UINavigationController(rootViewController: summaryView)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true) {
            self.removePinsAndPolylines()
            self.showHideTabBar(hide: false)
            self.zoomAndCenterUserLocation()
            self.statsView.resetLabels()
            UIApplication.tabBarController()?.settingsButton.isHidden = false
        }
    }
    
    @objc func goBackToUserLocation() {locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        zoomAndCenterUserLocation()
    }
    
    @objc func didDragMap(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            updateLocationButtonImage(to: "location")
        }
    }
    
    // MARK: - Music Player functions
    func showView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.mapView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 0.79, y: 0)
            self.locationButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 0.8, y: 0)
            self.slideOutView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 0.8, y: 0)
            let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 14))
            self.musicPlayerButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: .normal)
            self.mapView.isUserInteractionEnabled = false
        }
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.slideOutView.transform = .identity
            self.mapView.transform = .identity
            self.locationButton.transform = .identity
            let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 14))
            self.musicPlayerButton.setImage(UIImage(systemName: "music.note", withConfiguration: imageConfig), for: .normal)
            self.mapView.isUserInteractionEnabled = true
        }
    }
    
    @objc func showSlideOutView() {
        if isMusicPlayerShowing == false {
            showView()
        } else {
            closeView()
        }
        isMusicPlayerShowing.toggle()
    }
    
    @objc func didSlideView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .began {
            print("began")
        } else if gesture.state == .changed && translation.x < 0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.slideOutView.transform = CGAffineTransform(translationX: translation.x + UIScreen.main.bounds.width * 0.8, y: 0)
                self.locationButton.transform = CGAffineTransform(translationX: translation.x + UIScreen.main.bounds.width * 0.8, y: 0)
                self.mapView.transform = CGAffineTransform(translationX: translation.x + UIScreen.main.bounds.width * 0.79, y: 0)
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                if translation.x < -100 {
                    self.isMusicPlayerShowing = false
                    self.closeView()
                } else {
                    self.isMusicPlayerShowing = true
                    self.slideOutView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 0.8, y: 0)
                }
            }
        }
    }
    
    @objc func openMusicLibrary() {
        let musicPickerController = MPMediaPickerController()
        musicPickerController.allowsPickingMultipleItems = true
        musicPickerController.popoverPresentationController?.sourceView = musicLibraryButton
        musicPickerController.delegate = self
        present(musicPickerController, animated: true, completion: nil)
    }
    
    func displayMusicButtons(withAlpha a: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.musicPlayerButton.alpha = a
            self.musicLibraryButton.alpha = a
        }
    }
}

// MARK: - LocationManagerDelegate
extension ActivityMapVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            zoomAndCenterUserLocation()
            addPolyline(at: latestLocation.coordinate)
            if timerStatus != .Paused {
                let sumOfDistanceParts = calculateDistance(toLatestLocation: latestLocation)
                NotificationCenter.default.post(name: Notification.Name.didChangeDistance, object: nil, userInfo: ["distance": (totalActiveDistance + sumOfDistanceParts)])
            }
        }
    }
}

// MARK: - MapViewDelegate
extension ActivityMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if centerUserLocation {
            zoomAndCenterUserLocation()
            centerUserLocation = false
            updateLocationButtonImage(to: "location.fill")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = timerStatus == .Paused ? .systemPurple : .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ActivityMapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - StatsViewDelegate
extension ActivityMapVC: TimerDistanceViewDelegate {
    func showHoldProgressView() {
        UIView.animate(withDuration: 0.3) {
            self.loadView.alpha = 1
            NotificationCenter.default.post(name: .didPressFinish, object: nil)
        }
        
        closeView()
        self.isMusicPlayerShowing = false
    }
    
    func dismissHoldProgressView() {
        UIView.animate(withDuration: 0.3) {
            self.loadView.alpha = 0
        }
    }
    
    func startStopLocationUpdates(timerStatus: TimerStatus) {
        guard let currentLocation = locationManager.location?.coordinate else { return }
        self.timerStatus = timerStatus
        if timerStatus == .Paused {
            saveCoordinatesFrom(array: activeLocations)
            pausedLocations.append(currentLocation)
            totalActiveDistance += activeDistanceParts.reduce(0) { $0 + $1}
        } else if timerStatus == .Resumed {
            addPausedDistance()
            saveCoordinatesFrom(array: pausedLocations)
            activeDistanceParts.removeAll()
            pausedDistanceParts.removeAll()
            activeLocations.removeAll()
            pausedLocations.removeAll()
            activeLocations.append(currentLocation)
        }
    }
    
    func dropPin(withTitle title: String) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        if title == "Start" {
            mapAnnotation = MapAnnotation(title: "Start".localized(), coordinate: coordinate)
            mapView.addAnnotation(mapAnnotation!)
            activeLocations.append(coordinate)
            locationManager.startUpdatingLocation()
            totalActiveDistance = 0
            totalPausedDistance = 0
            timerStatus = .NotStarted
            showHideTabBar(hide: true)
            UIApplication.tabBarController()?.settingsButton.isHidden = true
            displayMusicButtons(withAlpha: 1)
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
            
            addPausedDistance()
            
            if let lastPaused = pausedLocations.last {
                mapAnnotation = MapAnnotation(title: "End".localized(), coordinate: lastPaused)
                mapView.addAnnotation(mapAnnotation!)
            }
            
            updateLocationButtonImage(to: "location")

            saveCoordinatesFrom(array: pausedLocations)
            takeSnapshot()
            mapView.showsUserLocation = true
            displayMusicButtons(withAlpha: 0)
        }
    }
    
    func addPausedDistance() {
        if pausedLocations.count >= 2 {
            let pausedCLLocations = pausedLocations.map({ return CLLocation(latitude: $0.latitude, longitude: $0.longitude) })

            for i in 0..<pausedLocations.count - 1 {
                let distanceBetweenTwoPoints = pausedCLLocations[i].distance(from: pausedCLLocations[i + 1])
                pausedDistanceParts.append(distanceBetweenTwoPoints)
            }

            let sumOfDistances = pausedDistanceParts.reduce(0, { (result, distance) in result + distance })
            totalPausedDistance += sumOfDistances
        }
    }
    
    func saveCoordinatesFrom(array: [CLLocationCoordinate2D]) {
        dictionaryId += 1
        
        var lat = [Double]()
        var lon = [Double]()
        
        for coordinates in array {
            lat.append(coordinates.latitude)
            lon.append(coordinates.longitude)
        }
        
        allLocations[dictionaryId] = [lat, lon]
    }
    
    func showHideTabBar(hide: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.tabBarController?.tabBar.isHidden = hide ? true : false
            self.statsViewHeightAnchor.isActive = false
            self.statsViewHeightAnchor = self.statsView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: hide ? 0.25 : 0.2)
            self.statsViewHeightAnchor.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func removePinsAndPolylines() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        activeLocations.removeAll()
        pausedLocations.removeAll()
        allLocations.removeAll()
        activeDistanceParts.removeAll()
        pausedDistanceParts.removeAll()
    }
}

// MARK: - MPMediaPickerControllerDelegate
extension ActivityMapVC: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        musicPlayer.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true, completion: nil)
        musicPlayer.play()
        slideOutView.scaleImage()
        NotificationCenter.default.post(name: Notification.Name.musicPlayerStartStopPlaying, object: nil, userInfo: nil)
    }
}

// MARK: - LocationRequestDelegate
extension ActivityMapVC: LocationRequestDelegate {
    func dismissLocationRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.5) {
                self.requestView.alpha = 0
            } completion: { _ in
                self.checkAuthStatus()
                self.requestView.removeFromSuperview()
                self.locationManager?.delegate = self
            }
        }
    }
}
