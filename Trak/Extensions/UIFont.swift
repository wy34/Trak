//
//  UIFont.swift
//  TrackingApp
//
//  Created by William Yeung on 12/15/20.
//

import UIKit


enum TrakFontStyle: String {
    case bold = "MADETommySoft-Bold"
    case medium = "MADETommySoft-Medium"
    case regular = "MADETommySoft-Regular"
    case light = "MADETommySoft-Light"
}

extension UIFont {
    static func customFont(withStyle style: TrakFontStyle, andSize size: CGFloat) -> UIFont? {
        guard let font = UIFont(name: style.rawValue, size: size) else { return nil }
        return font
    }
    
    // light fonts
    static var light10 = customFont(withStyle: .light, andSize: 10)
    static var light12 = customFont(withStyle: .light, andSize: 12)
    
    // medium fonts
    static var medium11 = customFont(withStyle: .medium, andSize: 11)
    static var medium12 = customFont(withStyle: .medium, andSize: 12)
    static var medium13 = customFont(withStyle: .medium, andSize: 13)
    static var medium14 = customFont(withStyle: .medium, andSize: 13)
    static var medium15 = customFont(withStyle: .medium, andSize: 15)
    static var medium16 = customFont(withStyle: .medium, andSize: 16)
    static var medium17 = customFont(withStyle: .medium, andSize: 17)
    static var medium25 = customFont(withStyle: .medium, andSize: 25)
    static var medium28 = customFont(withStyle: .medium, andSize: 28)

    // bold fonts
    static var labelFontSize = customFont(withStyle: .bold, andSize: UIFont.labelFontSize)
    static var bold10 = customFont(withStyle: .bold, andSize: 10)
    static var bold11 = customFont(withStyle: .bold, andSize: 11)
    static var bold12 = customFont(withStyle: .bold, andSize: 12)
    static var bold13 = customFont(withStyle: .bold, andSize: 13)
    static var bold14 = customFont(withStyle: .bold, andSize: 14)
    static var bold15 = customFont(withStyle: .bold, andSize: 15)
    static var bold16 = customFont(withStyle: .bold, andSize: 16)
    static var bold17 = customFont(withStyle: .bold, andSize: 17)
    static var bold18 = customFont(withStyle: .bold, andSize: 18)
    static var bold20 = customFont(withStyle: .bold, andSize: 20)
    static var bold22 = customFont(withStyle: .bold, andSize: 22)
    static var bold24 = customFont(withStyle: .bold, andSize: 24)
    static var bold25 = customFont(withStyle: .bold, andSize: 25)
    static var bold28 = customFont(withStyle: .bold, andSize: 28)
    static var bold35 = customFont(withStyle: .bold, andSize: 35)
}
