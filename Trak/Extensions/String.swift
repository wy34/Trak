//
//  String.swift
//  TrackingApp
//
//  Created by William Yeung on 1/13/21.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
