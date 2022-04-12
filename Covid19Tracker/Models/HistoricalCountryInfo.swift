//
//  HistoricalCountryInfo.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import CovidCharts

struct HistoricalCountryInfo {
    let country: String
    let timeline: [HistoricalTimelineDayInfo]

    static func from(model: HistoricalCountryInfoModel) -> HistoricalCountryInfo {
        HistoricalCountryInfo(country: model.country, timeline: HistoricalTimelineDayInfo.last7Days(from: model.timeline))
    }
}
