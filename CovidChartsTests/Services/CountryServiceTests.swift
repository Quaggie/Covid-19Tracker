//
//  CountryServiceTests.swift
//  DataTests
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
import Networking
@testable import CovidCharts

final class CountryServiceTests: XCTestCase {
    func test_fetchCountry_transformsCorrectURLParamsWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "Brazil"
        let expectedParameter = "/countries/\(country)"

        expectFetch(for: sut, country: country, networkManager: networkManager, with: expectedParameter) {
            let data = try! JSONEncoder().encode(anyCountryModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_transformsCorrectURLParamsWhenPassingStringWithSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "New Zealand"
        let expectedParameter = "/countries/\(country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"

        expectFetch(for: sut, country: country, networkManager: networkManager, with: expectedParameter) {
            let data = try! JSONEncoder().encode(anyCountryModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectCountryWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "Brazil"

        expectFetch(for: sut, country: country, with: .success(anyCountryModel())) {
            let data = try! JSONEncoder().encode(anyCountryModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectCountryWhenPassingStringWithSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "New Zealand"

        expectFetch(for: sut, country: country, with: .success(anyCountryModel())) {
            let data = try! JSONEncoder().encode(anyCountryModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_failsToDecodeUnexpectedType() {
        let (sut, networkManager) = makeSUT()
        let country = "AnyCountry"

        expectFetch(for: sut, country: country, with: .failure(.unparseable)) {
            let data = try! JSONEncoder().encode(anyCodable())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectErrorWhenNetworkFails() {
        let (sut, networkManager) = makeSUT()
        let country = "AnyCountry"

        expectFetch(for: sut, country: country, with: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
    }

    func test_fetchAll_transformsCorrectURLParamWhenSortingIsTrue() {
        let (sut, networkManager) = makeSUT()
        let sort = true

        expectFetchAll(for: sut, sort: sort, networkManager: networkManager, with: "/countries?sort=cases") {
            let data = try! JSONEncoder().encode([anyCountryModel()])
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_transformsCorrectURLParamWhenSortingIsFalse() {
        let (sut, networkManager) = makeSUT()
        let sort = false

        expectFetchAll(for: sut, sort: sort, networkManager: networkManager, with: "/countries") {
            let data = try! JSONEncoder().encode([anyCountryModel()])
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_returnsCorrectCountriesWhenSortingIsFalse() {
        let (sut, networkManager) = makeSUT()
        let sort = false

        expectFetchAll(for: sut, sort: sort, with: .success([anyCountryModel()])) {
            let data = try! JSONEncoder().encode([anyCountryModel()])
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_returnsCorrectCountriesWhenSortingIsTrue() {
        let (sut, networkManager) = makeSUT()
        let sort = true

        expectFetchAll(for: sut, sort: sort, with: .success([anyCountryModel()])) {
            let data = try! JSONEncoder().encode([anyCountryModel()])
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_failsToDecodeUnexpectedTypeWhenSortingIsFalse() {
        let (sut, networkManager) = makeSUT()
        let sort = false

        expectFetchAll(for: sut, sort: sort, with: .failure(.unparseable)) {
            let data = try! JSONEncoder().encode(anyCodable())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_failsToDecodeUnexpectedTypeWhenSortingIsTrue() {
        let (sut, networkManager) = makeSUT()
        let sort = true

        expectFetchAll(for: sut, sort: sort, with: .failure(.unparseable)) {
            let data = try! JSONEncoder().encode(anyCodable())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_returnsCorrectErrorWhenSortingIsFalseAndNetworkFails() {
        let (sut, networkManager) = makeSUT()
        let sort = false

        expectFetchAll(for: sut, sort: sort, with: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
    }

    func test_fetchAll_returnsCorrectErrorWhenSortingIsTrueAndNetworkFails() {
        let (sut, networkManager) = makeSUT()
        let sort = true

        expectFetchAll(for: sut, sort: sort, with: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
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

    func expectFetch(for sut: CountryService, country: String, networkManager: NetworkManagerSpy, with expectedParameter: String, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        sut.fetch(country: country) { _ in
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(networkManager.urlStrings, [expectedParameter], file: file, line: line)
    }

    func expectFetchAll(for sut: CountryService, sort: Bool, networkManager: NetworkManagerSpy, with expectedParameter: String, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        sut.fetchAll(sort: sort) { _ in
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(networkManager.urlStrings, [expectedParameter], file: file, line: line)
    }

    func expectFetch(for sut: CountryService, country: String, with expectedResult: Result<CountryModel, ConnectionError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<CountryModel, ConnectionError>?
        sut.fetch(country: country) { result in
            receivedResult = result
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        switch (receivedResult, expectedResult) {
        case (.success(let receivedData), .success(let expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let receivedError), .failure(let expectedError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Should've completed with \(expectedResult) instead got \(String(describing: receivedResult))", file: file, line: line)
        }
    }

    func expectFetchAll(for sut: CountryService, sort: Bool, with expectedResult: Result<[CountryModel], ConnectionError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<[CountryModel], ConnectionError>?
        sut.fetchAll(sort: sort) { result in
            receivedResult = result
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        switch (receivedResult, expectedResult) {
        case (.success(let receivedData), .success(let expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let receivedError), .failure(let expectedError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Should've completed with \(expectedResult) instead got \(String(describing: receivedResult))", file: file, line: line)
        }
    }

    private func anyCountryModel() -> CountryModel {
        CountryModel(country: "", countryInfo: .init(flag: ""), cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0, active: 0)
    }
}
