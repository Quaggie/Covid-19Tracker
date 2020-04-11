//
//  Int+DecimalFormat.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

extension Int {
    var decimalFormat: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))
    }
}
