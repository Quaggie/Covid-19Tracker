//
//  CountryInfo.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

struct CountryInfo {
    let flag: String

    static func from(model: CountryInfoModel) -> CountryInfo {
        CountryInfo(flag: model.flag)
    }
}
