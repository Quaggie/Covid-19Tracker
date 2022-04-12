//
//  Country.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

struct Country {
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

    static func from(model: CountryModel) -> Country {
        Country(
            country: model.country,
            countryInfo: CountryInfo.from(model: model.countryInfo),
            cases: model.cases,
            todayCases: model.todayCases,
            deaths: model.deaths,
            todayDeaths: model.todayDeaths,
            recovered: model.recovered,
            active: model.active
        )
    }
}
