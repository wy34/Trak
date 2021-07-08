//
//  MapSnapshotView.swift
//  TrackingApp
//
//  Created by William Yeung on 12/11/20.
//

import UIKit
import MapKit



class MapSnapshotView: UIView {
    // MARK: - Properties
    var activitySession: ActivitySession? {
        didSet {
            guard let session = activitySession, let coordinateDict = session.coordinatesDictionary else { return }
            let vm = ActivitySessionViewModel(session)
            activeDistanceLabelMiles.attributedText = vm.formattedTotalDistanceMilesString
            activeDurationLabel.attributedText = vm.formattedTotalDurationString
            drawPolyline(withCoordinates: coordinateDict)
        }
    }
    
    let gradientLayer = CAGradientLayer()
    var isPausedLocations = false
    
    // MARK: - Views
    private lazy var snapShotMapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.isUserInteractionEnabled = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
        
    private let polylineSymbol = CapsuleShape()
    
    private let activeDistanceLabelMiles = UILabel.createSnapshotOverlayLabels(withColor: .white)
    private let activeDurationLabel = UILabel.createSnapshotOverlayLabels(withColor: .white)
    
    private let milesWordLabel = UILabel.createCaptionLabel(withTitle: "MILES".localized(), withColor: UIColor.white, aligned: .center)
    private let durationWordLabel = UILabel.createCaptionLabel(withTitle: "DURATION".localized(), withColor: UIColor.white, aligned: .center)
    
    private lazy var activeMilesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activeDistanceLabelMiles, milesWordLabel])
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var activeDurationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activeDurationLabel, durationWordLabel])
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    private lazy var activeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [polylineSymbol, activeMilesStack, activeDurationStack])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.layer.zPosition = 2
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       gradientLayer.frame = bounds
   }

    // MARK: - Helper
    private func configureUI() {
        layer.shadowColor = UIColor(white: 0.25, alpha: 0.5).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
    }
    
    private func layoutUI() {
        addSubviews(snapShotMapView, activeStack)
        snapShotMapView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        
        activeStack.anchor(right: rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor,  paddingRight: 15, paddingBottom: 15, paddingLeft: 15)
    }
    
    private func setupGradient() {
        gradientLayer.type = .axial
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 0, y: 1)
        gradientLayer.zPosition = 1
        gradientLayer.opacity = 0.75
        layer.addSublayer(gradientLayer)
    }
    
    private func drawPolyline(withCoordinates coordinates: [Int: [[Double]]]) {
        let coordinatesArray = snapShotMapView.convertCoordinateDictionaryToCoordinateArrays(coordinates: coordinates)

        // drawing on polylines
        for i in 0..<coordinatesArray.count {
            isPausedLocations = i % 2 == 0 ? false : true
            let polyline = MKPolyline(coordinates: coordinatesArray[i], count: coordinatesArray[i].count)
            snapShotMapView.addOverlay(polyline)
        }
        
        snapShotMapView.addStartEndAnnotations(coordinates: coordinatesArray)
    }
}

// MARK: - MKMapview delegate
extension MapSnapshotView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = isPausedLocations ? .systemPurple : .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}
