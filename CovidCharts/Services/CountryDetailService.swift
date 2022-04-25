//
//  CountryDetailService.swift
//  CovidCharts
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

public protocol CountryDetailFetcher {
    func fetch(completion: @escaping (Result<CountryDetailModel, ConnectionError>) -> Void)
}

public final class CountryDetailService: CountryDetailFetcher {
    private let countryName: String
    private let countryFetcher: CountryFetcher
    private let historicalInfoFetcher: HistoricalInfoFetcher

    public init(countryName: String, countryFetcher: CountryFetcher, historicalInfoFetcher: HistoricalInfoFetcher) {
        self.countryName = countryName
        self.countryFetcher = countryFetcher
        self.historicalInfoFetcher = historicalInfoFetcher
    }

    public func fetch(completion: @escaping (Result<CountryDetailModel, ConnectionError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var countryModel: CountryModel?
        var historicalCountryInfoModel: HistoricalCountryInfoModel?
        var connectionError: ConnectionError?

        dispatchGroup.enter()
            countryFetcher.fetch(country: countryName) { result in
            dispatchGroup.leave()

            switch result {
            case .success(let model):
                countryModel = model
            case .failure(let error):
                connectionError = error
            }
        }

        dispatchGroup.enter()
        historicalInfoFetcher.fetch(country: countryName) { result in
            dispatchGroup.leave()

            switch result {
            case .success(let model):
                historicalCountryInfoModel = model
            case .failure(let error):
                connectionError = error
            }
        }

        dispatchGroup.notify(queue: .global(qos: .default)) { [weak self] in
            guard let self = self else { return }

            let result = self.transformResult(
                country: countryModel,
                historicalCountryInfo: historicalCountryInfoModel,
                error: connectionError
            )
            completion(result)
        }
    }

    private func transformResult(
        country: CountryModel?,
        historicalCountryInfo: HistoricalCountryInfoModel?,
        error: ConnectionError?
    ) -> Result<CountryDetailModel, ConnectionError> {
        if let country = country, let historicalCountryInfo = historicalCountryInfo {
            let model = CountryDetailModel(country: country, historicalCountryInfo: historicalCountryInfo)
            return .success(model)
        }
        if let error = error {
            return .failure(error)
        }

        return .failure(.unexpected)
    }
}
