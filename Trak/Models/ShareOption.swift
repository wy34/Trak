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
    ShareOption(image: UIImage(named: "message")!, optionName: "MESSAGE".localized()),
    ShareOption(image: UIImage(named: "download")!, optionName: "DOWNLOAD".localized()),
    ShareOption(image: UIImage(named: "more")!, optionName: "MORE".localized()),
]
