//
//  Timeline.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Data

struct Timeline: Equatable {
    let cases: Int
    let active: Int
    let deaths: Int
    let recovered: Int
    let todayCases: Int
    let todayDeaths: Int

    static func from(model: TimelineModel) -> Timeline {
        Timeline(
            cases: model.cases,
            active: model.active,
            deaths: model.deaths,
            recovered: model.recovered,
            todayCases: model.todayCases,
            todayDeaths: model.todayDeaths
        )
    }
}
