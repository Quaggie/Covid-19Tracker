//
//  Country.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

struct Country: Codable {
    let country: String
    let countryInfo: CountryInfo
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let active: Int

    var timeline: Timeline {
        Timeline(cases: cases, active: active, deaths: deaths, recovered: recovered, todayCases: todayCases, todayDeaths: todayDeaths)
    }
}
