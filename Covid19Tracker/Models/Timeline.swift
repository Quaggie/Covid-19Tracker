//
//  Timeline.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

struct Timeline: Codable {
    let cases: Int
    let active: Int
    let deaths: Int
    let recovered: Int
    let todayCases: Int
    let todayDeaths: Int
}
