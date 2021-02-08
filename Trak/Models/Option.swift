//
//  MoreActions.swift
//  TrackingApp
//
//  Created by William Yeung on 1/6/21.
//

import UIKit

struct Option<T> {
    let title: T
    let image: String
}

enum Action: String {
    case Share
    case Edit
    case Delete
    case Cancel
}

