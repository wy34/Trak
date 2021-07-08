//
//  StatsView.swift
//  TrackingApp
//
//  Created by William Yeung on 11/20/20.
//

import UIKit
import MapKit

protocol TimerDistanceViewDelegate: AnyObject {
    func dropPin(withTitle title: String)
    func startStopLocationUpdates(timerStatus: TimerStatus)
    func showHoldProgressView()
    func dismissHoldProgressView()
}

class TimerDistanceView: UIView {
    // MARK: - Properties
    private var timer: Timer?
    private var timeElapsed = 0
    private var timerStatus: TimerStatus = .NotStarted
    private var distanceInMeters: CLLocationDistance = 0.0
    private var showDistanceInMeters = false
    weak var delegate: TimerDistanceViewDelegate?
    
    // MARK: - Views
    private let durationLabel = UILabel.createHeaderLabel(withTitle: "0:00", andFont: UIFont.bold35)
    private let durationCaptionLabel = UILabel.createCaptionLabel(withTitle: "DURATION".localized())
    private let distanceLabel = UILabel.createHeaderLabel(withTitle: "0.00", andFont: UIFont.bold35)
    private let distanceCaptionLabel = UILabel.createCaptionLabel(withTitle: "DISTANCE (MI)".localized())

    lazy var startPauseResumeButton: UIButton = {
        let button = UIButton.createWorkoutButtons(withTitle: "START ACTIVITY".localized(), bgColor: .systemGreen, isFinishButton: false)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        return button
    }()
        
    private lazy var finishButton: UIButton = {
        let button = UIButton.createWorkoutButtons(withTitle: "HOLD TO FINISH".localized(), bgColor: .systemRed, isFinishButton: true)
        button.addTarget(self, action: #selector(handleFinishPressDown), for: .touchDown)
        button.addTarget(self, action: #selector(handleFinishPressUp), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleHoldToFinish))
        longPress.minimumPressDuration = 0.9
        button.addGestureRecognizer(longPress)
        
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startPauseResumeButton, finishButton])
        stack.distribution = .fillEqually
        stack.spacing = 15
        return stack
    }()
    
    private let switchUnitsButton = Button3D()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutViews()
        setupNotificationObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = UIColor.StandardDarkMode
        layer.shadowColor = UIColor(white: 0.25, alpha: 0.5).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        switchUnitsButton.layer.transform = CATransform3DMakeRotation(-0.5, 1, 0, 0)
    }
    
    private func layoutViews() {
        addSubviews(buttonStack, durationLabel, durationCaptionLabel, distanceLabel, distanceCaptionLabel, switchUnitsButton)
        
        buttonStack.setDimension(hConst: 35)
        buttonStack.center(to: self, by: .centerX)
        buttonStack.anchor(right: rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor, paddingRight: 20, paddingBottom: 12, paddingLeft: 20)
        
        durationLabel.setDimension(width: widthAnchor, wMult: 0.35)
        durationLabel.setDimension(hConst: 50)
        durationLabel.center(to: self, by: .centerX, withMultiplierOf: 0.6)
        durationLabel.center(to: self, by: .centerY, withMultiplierOf: 0.5)
    
        durationCaptionLabel.center(to: durationLabel, by: .centerX)
        durationCaptionLabel.anchor(top: durationLabel.bottomAnchor, paddingTop: -3)
        
        distanceLabel.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.35, hMult: 0.3)
        distanceLabel.center(to: self, by: .centerX, withMultiplierOf: 1.4)
        distanceLabel.center(to: durationLabel, by: .centerY)

        distanceCaptionLabel.center(to: distanceLabel, by: .centerX)
        distanceCaptionLabel.center(to: durationCaptionLabel, by: .centerY)
        
        switchUnitsButton.setDimension(wConst: 25, hConst: 20)
        switchUnitsButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        switchUnitsButton.delegate = self
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDurationLabel), name: Notification.Name.didUpdateTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDistanceLabel), name: Notification.Name.didChangeDistance, object: nil)
    }
    
    private func finishTimer() {
        timerStatus = .NotStarted
        finishButton.isHidden = true
        finishButton.alpha = 0
        startPauseResumeButton.setTitle("START NEW ACTIVITY".localized(), for: .normal)
        startPauseResumeButton.backgroundColor = #colorLiteral(red: 0, green: 0.746263206, blue: 0.2877824903, alpha: 1)
        delegate?.dropPin(withTitle: "End")
    }
    
    private func configureStartTimer() {
        timerStatus = .Resumed
        ActivityTimer.shared.invalidate()
        ActivityTimer.shared.start()
        delegate?.dropPin(withTitle: "Start")
        startPauseResumeButton.setTitle("PAUSE".localized(), for: .normal)
        startPauseResumeButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        durationLabel.text = ActivityTimer.shared.conciseFormattedTime
    }
    
    private func configurePauseTimer() {
        timerStatus = .Paused
        ActivityTimer.shared.pause()
        delegate?.startStopLocationUpdates(timerStatus: timerStatus)
        buttonStack.removeArrangedSubview(startPauseResumeButton)
        finishButton.isHidden = false
        finishButton.alpha = 1
        buttonStack.addArrangedSubview(startPauseResumeButton)
        startPauseResumeButton.setTitle("RESUME".localized(), for: .normal)
        startPauseResumeButton.backgroundColor = #colorLiteral(red: 0, green: 0.746263206, blue: 0.2877824903, alpha: 1)
    }
    
    private func configureResumeTimer() {
        timerStatus = .Resumed
        ActivityTimer.shared.resume()
        delegate?.startStopLocationUpdates(timerStatus: timerStatus)
        finishButton.isHidden = true
        finishButton.alpha = 0
        startPauseResumeButton.setTitle("PAUSE".localized(), for: .normal)
        startPauseResumeButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    func resetLabels() {
        distanceLabel.text = "0.00"
        ActivityTimer.shared.invalidate()
    }
    
    // MARK: - Selectors
    @objc func startTimer() {
        if timerStatus == .NotStarted {
            configureStartTimer()
        } else if timerStatus == .Resumed {
            configurePauseTimer()
        } else if timerStatus == .Paused {
            configureResumeTimer()
        }
    }
    
    @objc func handleFinishPressDown() {
        delegate?.showHoldProgressView()
    }
    
    @objc func handleFinishPressUp() {
        delegate?.dismissHoldProgressView()
    }
    
    @objc func handleHoldToFinish(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            finishTimer()
            delegate?.dismissHoldProgressView()
        }
    }
    
    @objc func updateDurationLabel() {
        durationLabel.text = ActivityTimer.shared.conciseFormattedTime
    }
    
    @objc func updateDistanceLabel(notification: Notification) {
        if let distanceDictionary = notification.userInfo as Dictionary? {
            if let distance = distanceDictionary["distance"] as? CLLocationDistance {
                self.distanceInMeters = distance
                if showDistanceInMeters {
                    distanceLabel.text = String(format: "%.2f", distanceInMeters)
                } else {
                    distanceLabel.text = String(format: "%.2f", distance * 0.000621371)
                }
            }
        }
    }
}

// MARK: - Button3D Delegate
extension TimerDistanceView: Button3DDelegate {
    func handleUnitSwitch(isDown: Bool) {
        self.showDistanceInMeters = isDown
        if isDown {
            distanceLabel.text = String(format: "%.2f", distanceInMeters)
            distanceCaptionLabel.text = "DISTANCE (m)"
        } else {
            distanceLabel.text = String(format: "%.2f", distanceInMeters * 0.000621371)
            distanceCaptionLabel.text = "DISTANCE (MI)"
        }
    }
}
