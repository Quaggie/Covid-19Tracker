//
//  Double+DecimalFormat.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

extension Double {
    var decimalFormat: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self))
    }

    var shortened: String {
        switch self {
        case 1_000_000_000_000...:
            guard let formatted = (self / 1_000_000_000_000).decimalFormat else { return "--" }
            return "\(formatted)T"
        case 1_000_000_000...:
            guard let formatted = (self / 1_000_000_000).decimalFormat else { return "--" }
            return "\(formatted)B"
        case 1_000_000...:
            guard let formatted = (self / 1_000_000).decimalFormat else { return "--" }
            return "\(formatted)M"
        case 1_000...:
            guard let formatted = (self / 1_000).decimalFormat else { return "--" }
            return "\(formatted)K"
        default:
            return "\(Int(self))"
        }
    }
}
