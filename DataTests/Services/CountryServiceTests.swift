//
//  CountryServiceTests.swift
//  DataTests
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
import Networking
@testable import Data

final class CountryServiceTests: XCTestCase {
    func test_fetchCountry_transformsCorrectURLParamsWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "Brazil"

        let exp = expectation(description: #function)
        sut.fetch(country: country) { result in
            exp.fulfill()
        }
        let countryModel = CountryModel(country: "", countryInfo: .init(flag: ""), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0, active: 0)
        let data = try! JSONEncoder().encode(countryModel)
        networkManager.complete(with: .success(data))
        wait(for: [exp], timeout: 1)

        let expectedParameter = "/countries/\(country)"
        XCTAssertEqual(networkManager.urlStrings, [expectedParameter])
    }

    func test_fetchCountry_returnsCorrectCountryWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "New Zealand"

        let exp = expectation(description: #function)
        var receivedResult: Result<CountryModel, WebserviceError>?
        sut.fetch(country: country) { result in
            receivedResult = result
            exp.fulfill()
        }

        let countryModel = CountryModel(country: "", countryInfo: .init(flag: ""), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0, active: 0)
        let data = try! JSONEncoder().encode(countryModel)
        networkManager.complete(with: .success(data))

        wait(for: [exp], timeout: 1)
        let expectedResult: Result<CountryModel, WebserviceError> = .success(countryModel)

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

extension CountryServiceTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (CountryService, NetworkManagerSpy) {
        let networkManager = NetworkManagerSpy()
        let service = CountryService(networkManager: networkManager)
        checkMemoryLeak(for: networkManager, file: file, line: line)
        checkMemoryLeak(for: service, file: file, line: line)
        return (service, networkManager)
    }
}
