//
//  UIView+Shadow.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

extension UIView {
    func applyShadow(color: UIColor,
                     offset: CGSize = CGSize(width: 0.0, height: 2.0),
                     opacity: Float = 0.2,
                     radius: CGFloat = 1.0,
                     shadowPath: CGPath? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = Float(opacity)
        layer.masksToBounds = false
        if let shadowPath = shadowPath {
            layer.shadowPath = shadowPath
        }
    }
}
