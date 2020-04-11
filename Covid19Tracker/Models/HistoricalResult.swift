//
//  HistoricalResult.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

struct HistoricalResult: Codable {
    let country: Country
    let cases: Int
    let deaths: Int
    let recovered: Int
}
