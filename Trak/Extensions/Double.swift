//
//  Double.swift
//  TrackingApp
//
//  Created by William Yeung on 1/22/21.
//

import Foundation

extension Double {
    func roundDownToPlace(_ num: Int) -> Double {
        let base = pow(10, Double(num))
        return floor(self * base) / base
    }
}
