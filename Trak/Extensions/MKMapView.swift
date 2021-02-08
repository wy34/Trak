//
//  MKMapView.swift
//  TrackingApp
//
//  Created by William Yeung on 1/13/21.
//

import MapKit

extension MKMapView {
    func zoomAndCenterWithPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        if let first = self.overlays.first {
            let rect = self.overlays.reduce(first.boundingMapRect, { $0.union($1.boundingMapRect) })
            self.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right), animated: true)
        }
    }
    
    func convertCoordinateDictionaryToCoordinateArrays(coordinates: [Int: [[Double]]]) -> [[CLLocationCoordinate2D]] {
        let sortedKeys = coordinates.keys.sorted(by: <)
        var finalArray = [[CLLocationCoordinate2D]]()
        
        for key in sortedKeys {
            guard let latLonArray = coordinates[key] else { return [] } // [[1,2,3], [1,2,3]]
            
            let lat = latLonArray[0]
            let lon = latLonArray[1]
            var coordinateArray = [CLLocationCoordinate2D]()
            
            for i in 0..<lat.count {
                let coordinate = CLLocationCoordinate2D(latitude: lat[i], longitude: lon[i])
                coordinateArray.append(coordinate)
            }
            
            finalArray.append(coordinateArray)
        }
        
        return finalArray
    }
    
    func addStartEndAnnotations(coordinates: [[CLLocationCoordinate2D]]) {
        let startAnnotation = MapAnnotation(title: "Start".localized(), coordinate: coordinates[0][0])
        let endAnnotation = MapAnnotation(title: "End".localized(), coordinate: coordinates[coordinates.count - 1][coordinates[coordinates.count - 1].count - 1])
        self.addAnnotation(startAnnotation)
        self.addAnnotation(endAnnotation)
        self.zoomAndCenterWithPadding(top: 35, left: 35, bottom: 50, right: 35)
    }
}
