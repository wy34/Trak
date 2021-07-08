//
//  MapAnnotation.swift
//  TrackingApp
//
//  Created by William Yeung on 11/24/20.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    // MARK: - Properties
    var coordinate: CLLocationCoordinate2D
    var title: String?

    // MARK: - Init
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

