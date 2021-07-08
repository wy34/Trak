//
//  UIImage.swift
//  TrackingApp
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

extension UIImageView {
    static func createVolumeImageViews(withImage image: UIImage) -> UIImageView {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 10))
        iv.image = image.applyingSymbolConfiguration(config)
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        return iv
    }
}

struct Assets {
    static let message = UIImage(named: "message")!
    static let download = UIImage(named: "download")!
    static let more = UIImage(named: "more")!
    static let route = UIImage(named: "route")!
    static let musicNotePH = UIImage(named: "musicNotePlaceholder")!
    static let road = UIImage(named: "road")!
    static let walk = UIImage(named: "walk")!
    static let finish = UIImage(named: "finish")!
}

struct SFSymbols {
    static let chart = UIImage(systemName: "chart.bar.xaxis")!
    static let diagonalArrowUp = UIImage(systemName: "arrow.up.forward.app")!
    static let circleBadge = UIImage(systemName: "circlebadge.fill")!
    static let map = UIImage(systemName: "map")!
    static let bulletList = UIImage(systemName: "list.bullet")!
    static let play = UIImage(systemName: "play.fill")!
    static let pause = UIImage(systemName: "pause.fill")!
    static let musicNote = UIImage(systemName: "music.note")!
    static let xmark = UIImage(systemName: "xmark")!
    static let xmarkCircle = UIImage(systemName: "xmark.circle")!
    static let location = UIImage(systemName: "location")!
    static let locationFill = UIImage(systemName: "location.fill")!
    static let pencil = UIImage(systemName: "pencil")!
    static let ellipsis = UIImage(systemName: "ellipsis")!
    static let person = UIImage(systemName: "person.circle")!
    static let expandArrows = UIImage(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")!
    static let triangleLeft = UIImage(systemName: "arrowtriangle.left.fill")!
    static let triangleRight = UIImage(systemName: "arrowtriangle.right.fill")!
    static let moonFill = UIImage(systemName: "moon.fill")!
    static let faceid = UIImage(systemName: "faceid")!
    static let globe = UIImage(systemName: "globe")!
    static let trash = UIImage(systemName: "trash")!
    static let trashFill = UIImage(systemName: "trash.fill")!
    static let squareArrowUp = UIImage(systemName: "square.and.arrow.up")!
    static let pencilCircle = UIImage(systemName: "pencil.circle")!
    static let photo = UIImage(systemName: "photo")!
    static let camera = UIImage(systemName: "camera")!
    static let volumeDown = UIImage(systemName: "speaker.fill")!
    static let volumeUp = UIImage(systemName: "speaker.wave.3.fill")!
}
