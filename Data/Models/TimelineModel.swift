//
//  TimelineModel.swift
//  Data
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

public struct TimelineModel: Codable, Equatable {
    public let cases: Int
    public let active: Int
    public let deaths: Int
    public let recovered: Int
    public let todayCases: Int
    public let todayDeaths: Int
}
