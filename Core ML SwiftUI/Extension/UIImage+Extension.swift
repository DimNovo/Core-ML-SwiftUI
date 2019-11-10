//
//  UIImage+Extension.swift
//  Core ML SwiftUI
//
//  Created by Dmitry Novosyolov on 10/11/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            fatalError("Can't identify image orientation")
        }
    }
}
