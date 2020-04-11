//
//  UIView+Gradient.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [colors]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
