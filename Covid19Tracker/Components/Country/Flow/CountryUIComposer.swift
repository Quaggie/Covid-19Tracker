//
//  CountryUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

final class CountryUIComposer: UIComposer {
    let countryName: String

    init(countryName: String) {
        self.countryName = countryName
    }

    func compose() -> CountryViewController {
        let presenter = CountryPresenter(
            countryName: countryName,
            countryFetcher: CountryService(),
            historicalInfoFetcher: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        return CountryViewController(delegate: CountryTrackerAdapter(), presenter: presenter)
    }
}
