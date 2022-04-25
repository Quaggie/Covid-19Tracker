//
//  HistoricalCountryInfoModel.swift
//  CovidChartsTests
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

@testable import CovidCharts

extension HistoricalCountryInfoModel {
    static func mock() -> Self {
        HistoricalCountryInfoModel(country: "", timeline: .init(cases: [:], deaths: [:], recovered: [:]))
    }
}
