//
//  HistoricalCountryTimeline.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

struct HistoricalCountryTimeline {
    let cases: [String: Int]
    let deaths: [String: Int]
    let recovered: [String: Int]

    static func from(model: HistoricalCountryInfoModel.Timeline) -> HistoricalCountryTimeline {
        HistoricalCountryTimeline(cases: model.cases, deaths: model.deaths, recovered: model.recovered)
    }
}
