//
//  CountryPresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

protocol CountryPresenterDelegate {
    var countryName: String { get }

    func fetch(completion: @escaping (Result<CountryViewModel, ConnectionError>) -> Void)
}

final class CountryPresenter: CountryPresenterDelegate {
    let countryName: String
    private let countryFetcher: CountryFetcher
    private let historicalInfoFetcher: HistoricalInfoFetcher

    init(
        countryName: String,
        countryFetcher: CountryFetcher,
        historicalInfoFetcher: HistoricalInfoFetcher
    ) {
        self.countryName = countryName
        self.countryFetcher = countryFetcher
        self.historicalInfoFetcher = historicalInfoFetcher
    }

    func fetch(completion: @escaping (Result<CountryViewModel, ConnectionError>) -> Void) {
        countryFetcher.fetch(country: countryName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let countryModel):
                self.historicalInfoFetcher.fetch(country: countryModel.country) { result in
                    switch result {
                    case .success(let historicalCountryInfoModel):
                        let country = Country.from(model: countryModel)
                        let historicalCountryInfo = HistoricalCountryInfo.from(model: historicalCountryInfoModel)
                        let viewModel = CountryViewModel(country: country, historicalCountryInfo: historicalCountryInfo)
                        completion(.success(viewModel))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
