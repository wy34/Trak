//
//  ShareOption.swift
//  TrackingApp
//
//  Created by William Yeung on 12/30/20.
//

import UIKit

struct ShareOption {
    let image: UIImage
    let optionName: String
}

let options = [
    ShareOption(image: Assets.message, optionName: "MESSAGE".localized()),
    ShareOption(image: Assets.download, optionName: "DOWNLOAD".localized()),
    ShareOption(image: Assets.more, optionName: "MORE".localized()),
]
