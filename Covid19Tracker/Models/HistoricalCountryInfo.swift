//
//  HistoricalCountryInfo.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

struct HistoricalCountryInfoResponse: Codable {
    let country: String
    let timeline: HistoricalTimelineResponse
}

struct HistoricalTimelineResponse: Codable {
    let cases: [String: Int]
    let deaths: [String: Int]
    let recovered: [String: Int]
}
