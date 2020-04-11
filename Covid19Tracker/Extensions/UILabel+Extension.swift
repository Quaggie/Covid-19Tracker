//
//  UILabel+Extension.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

extension UILabel {
    convenience public init(text: String? = nil,
                            font: UIFont? = nil,
                            textColor: UIColor? = nil,
                            textAlignment: NSTextAlignment = .left,
                            numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

