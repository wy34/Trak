//
//  ExpandedSnapshotView.swift
//  TrackingApp
//
//  Created by William Yeung on 12/13/20.
//

import UIKit
import MapKit

protocol ExpandedSnapshotMapViewDelegate: AnyObject {
    func dismissView()
}

class ExpandedSnapshotMapView: UIView {
    // MARK: - Properties
    weak var delegate: ExpandedSnapshotMapViewDelegate?
    
    var routeCoordinates: [Int: [[Double]]]? {
        didSet {
            guard let coordinates = routeCoordinates else { return }
            mapView.removeAnnotations(mapView.annotations)
            mapView.removeOverlays(mapView.overlays)
            drawPolyline(withCoordinates: coordinates)
        }
    }
    
    var isPausedLocations = false

    // MARK: - Views
    private let headerView = UIView.createView(withBgColor: UIColor.StandardDarkMode, alpha: 1, andCornerRadius: 0)
    private let blueBorderLine = UIView.createBlueBorderLine()
    
    private let closeButton: UIButton = {
        let button = UIButton.createControlButtons(withImage: SFSymbols.xmarkCircle, withTitle: nil, andTintColor: UIColor.InvertedDarkMode)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private let mapTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["STANDARD".localized(), "HYBRID".localized(), "SATELLITE".localized()])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = UIColor.StandardDarkMode
        sc.addTarget(self, action: #selector(handleMapTypeChanged), for: .valueChanged)
        return sc
    }()

    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.mapType = .standard
        mv.delegate = self
        return mv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layoutViews() {
        addSubviews(headerView, mapView)
    
        headerView.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, left: leftAnchor)
        headerView.setDimension(hConst: 85)
        
        headerView.addSubviews(blueBorderLine, closeButton, mapTypeSegmentedControl)
        
        blueBorderLine.anchor(top: headerView.topAnchor)
        closeButton.anchor(top: blueBorderLine.bottomAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 10)
        mapTypeSegmentedControl.anchor(top: closeButton.bottomAnchor, right: headerView.rightAnchor, left: headerView.leftAnchor, paddingTop: 10, paddingRight: 10, paddingBottom: 7.5, paddingLeft: 10)
        
        mapView.anchor(top: headerView.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
    }
    

    private func drawPolyline(withCoordinates coordinates: [Int: [[Double]]]) {
        let coordinatesArray = mapView.convertCoordinateDictionaryToCoordinateArrays(coordinates: coordinates)

        for i in 0..<coordinatesArray.count {
            isPausedLocations = i % 2 == 0 ? false : true
            let polyline = MKPolyline(coordinates: coordinatesArray[i], count: coordinatesArray[i].count)
            mapView.addOverlay(polyline)
        }
        
        mapView.addStartEndAnnotations(coordinates: coordinatesArray)
    }
    
    // MARK: - Selectors
    @objc func handleClose() {
        delegate?.dismissView()
    }
    
    @objc func handleMapTypeChanged() {
        let selectedIndex = mapTypeSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .hybrid
            case 2:
                mapView.mapType = .satellite
            default:
                break
        }
    }
}

// MARK: - MapViewDelegate
extension ExpandedSnapshotMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = isPausedLocations ? .systemPurple : .systemBlue
        renderer.lineWidth = 3
        return renderer
    }
}
