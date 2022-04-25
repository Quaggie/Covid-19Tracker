//
//  CountryModel.swift
//  CovidChartsTests
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

@testable import CovidCharts

extension CountryModel {
    static func mock() -> Self {
        CountryModel(country: "", countryInfo: .init(flag: ""), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0, active: 0)
    }
}
