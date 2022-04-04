//
//  HistoricalCountryInfo.swift
//  Data
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

public struct HistoricalCountryInfoModel: Codable {
    public struct Timeline: Codable {
        public let cases: [String: Int]
        public let deaths: [String: Int]
        public let recovered: [String: Int]
    }

    public let country: String
    public let timeline: Timeline
}
