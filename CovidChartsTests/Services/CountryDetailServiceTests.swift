//
//  CountryDetailServiceTests.swift
//  CovidChartsTests
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import CovidCharts

final class CountryDetailServiceTests: XCTestCase {
    func test_fetch_returnsCorrectResultForBothSuccessfulResults() {
        let countryFetcher = CountryFetcherSpy(result: .success(CountryModel.mock()))
        let historicalInfoFetcher = HistoricalInfoFetcherSpy(result: .success(HistoricalCountryInfoModel.mock()))
        let sut = CountryDetailService(countryName: "Brazil", countryFetcher: countryFetcher, historicalInfoFetcher: historicalInfoFetcher)
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: countryFetcher)
        checkMemoryLeak(for: historicalInfoFetcher)

        let exp = expectation(description: #function)
        var receivedResult: Result<CountryDetailModel, ConnectionError>?
        sut.fetch { result in
            receivedResult = result
            exp.fulfill()
        }

        waitForExpectations(timeout: 1)

        let expectedResult = Result<CountryDetailModel, ConnectionError>.success(CountryDetailModel(country: CountryModel.mock(), historicalCountryInfo: HistoricalCountryInfoModel.mock()))
        switch (receivedResult, expectedResult) {
        case (.success(let receivedData), .success(let expectedData)):
            XCTAssertEqual(receivedData, expectedData)
        case (.failure(let receivedError), .failure(let expectedError)):
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Should've completed with \(expectedResult) instead got \(String(describing: receivedResult))")
        }
    }
}

private final class CountryFetcherSpy: CountryFetcher {
    private let result: Result<CountryModel, ConnectionError>

    init(result: Result<CountryModel, ConnectionError>) {
        self.result = result
    }

    func fetch(country: String, completion: @escaping (Result<CountryModel, ConnectionError>) -> Void) {
        completion(result)
    }

    func fetchAll(sort: Bool, completion: @escaping (Result<[CountryModel], ConnectionError>) -> Void) {
        fatalError("Function not supposed to be called")
    }
}

private final class HistoricalInfoFetcherSpy: HistoricalInfoFetcher {
    private let result: Result<HistoricalCountryInfoModel, ConnectionError>

    init(result: Result<HistoricalCountryInfoModel, ConnectionError>) {
        self.result = result
    }

    func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfoModel, ConnectionError>) -> Void) {
        completion(result)
    }

    func fetchAll(completion: @escaping (Result<HistoricalCountryInfoModel.Timeline, ConnectionError>) -> Void) {
        fatalError("Function not supposed to be called")
    }
}
