//
//  HistoricalInfoServiceTests.swift
//  DataTests
//
//  Created by Jonathan Bijos on 08/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
import Networking
@testable import Data

final class HistoricalInfoServiceTests: XCTestCase {
    func test_fetchCountry_transformsCorrectURLParamsWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "Brazil"
        let expectedParameter = "/historical/\(country)?lastdays=7"

        expectFetch(for: sut, country: country, networkManager: networkManager, withExpectedParameter: expectedParameter) {
            let data = try! JSONEncoder().encode(anyHistoricalCountryInfoModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_transformsCorrectURLParamsWhenPassingStringWithSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "New Zealand"
        let expectedParameter = "/historical/\(country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)?lastdays=7"

        expectFetch(for: sut, country: country, networkManager: networkManager, withExpectedParameter: expectedParameter) {
            let data = try! JSONEncoder().encode(anyHistoricalCountryInfoModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectCountryWhenPassingStringWithoutSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "Brazil"

        expectFetch(for: sut, country: country, withExpectedResult: .success(anyHistoricalCountryInfoModel())) {
            let data = try! JSONEncoder().encode(anyHistoricalCountryInfoModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectCountryWhenPassingStringWithSpaces() {
        let (sut, networkManager) = makeSUT()
        let country = "New Zealand"

        expectFetch(for: sut, country: country, withExpectedResult: .success(anyHistoricalCountryInfoModel())) {
            let data = try! JSONEncoder().encode(anyHistoricalCountryInfoModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_failsToDecodeUnexpectedType() {
        let (sut, networkManager) = makeSUT()
        let country = "AnyCountry"

        expectFetch(for: sut, country: country, withExpectedResult: .failure(.unparseable)) {
            let data = try! JSONEncoder().encode(anyCodable())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCountry_returnsCorrectErrorWhenNetworkFails() {
        let (sut, networkManager) = makeSUT()
        let country = "AnyCountry"

        expectFetch(for: sut, country: country, withExpectedResult: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
    }

    func test_fetchAll_transformsCorrectURLParam() {
        let (sut, networkManager) = makeSUT()

        expectFetchAll(for: sut, networkManager: networkManager, with: "/historical/all?lastdays=7") {
            let data = try! JSONEncoder().encode([anyHistoricalCountryInfoModel()])
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_returnsCorrectCountries() {
        let (sut, networkManager) = makeSUT()

        expectFetchAll(for: sut, withExpectedResult: .success(anyHistoricalCountryInfoTimelineModel())) {
            let data = try! JSONEncoder().encode(anyHistoricalCountryInfoTimelineModel())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_failsToDecodeUnexpectedType() {
        let (sut, networkManager) = makeSUT()

        expectFetchAll(for: sut, withExpectedResult: .failure(.unparseable)) {
            let data = try! JSONEncoder().encode(anyCodable())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchAll_returnsCorrectErrorWhenNetworkFails() {
        let (sut, networkManager) = makeSUT()

        expectFetchAll(for: sut, withExpectedResult: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
    }
}

extension HistoricalInfoServiceTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (HistoricalInfoService, NetworkManagerSpy) {
        let networkManager = NetworkManagerSpy()
        let service = HistoricalInfoService(networkManager: networkManager)
        checkMemoryLeak(for: networkManager, file: file, line: line)
        checkMemoryLeak(for: service, file: file, line: line)
        return (service, networkManager)
    }

    func expectFetch(for sut: HistoricalInfoService, country: String, networkManager: NetworkManagerSpy, withExpectedParameter expectedParameter: String, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        sut.fetch(country: country) { _ in
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(networkManager.urlStrings, [expectedParameter], file: file, line: line)
    }

    func expectFetchAll(for sut: HistoricalInfoService, networkManager: NetworkManagerSpy, with expectedParameter: String, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        sut.fetchAll { _ in
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(networkManager.urlStrings, [expectedParameter], file: file, line: line)
    }

    func expectFetch(for sut: HistoricalInfoService, country: String, withExpectedResult expectedResult: Result<HistoricalCountryInfoModel, ConnectionError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<HistoricalCountryInfoModel, ConnectionError>?
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

    func expectFetchAll(for sut: HistoricalInfoService, withExpectedResult expectedResult: Result<HistoricalCountryInfoModel.Timeline, ConnectionError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<HistoricalCountryInfoModel.Timeline, ConnectionError>?
        sut.fetchAll { result in
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

    private func anyHistoricalCountryInfoModel() -> HistoricalCountryInfoModel {
        HistoricalCountryInfoModel(country: "", timeline: .init(cases: [:], deaths: [:], recovered: [:]))
    }

    private func anyHistoricalCountryInfoTimelineModel() -> HistoricalCountryInfoModel.Timeline {
        HistoricalCountryInfoModel.Timeline(cases: [:], deaths: [:], recovered: [:])
    }
}

