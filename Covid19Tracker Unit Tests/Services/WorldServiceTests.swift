//
//  WorldServiceTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 27/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class WorldServiceTests: XCTestCase {
    func test_fetchCases_returnsTimelineOnSuccess() throws {
        let (sut, networkManager) = makeSUT()

        let timeline = Timeline(cases: 0, active: 0, deaths: 0, recovered: 0, todayCases: 0, todayDeaths: 0)
        let data = try JSONEncoder().encode(timeline)
        let exp = expectation(description: #function)
        var receivedResult: Result<Timeline, WebserviceError>?
        let expectedResult: Result<Timeline, WebserviceError> = .success(timeline)
        sut.fetchCases { result in
            receivedResult = result
            exp.fulfill()
        }
        networkManager.complete(with: .success(data))
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(expectedResult, receivedResult)
    }

    func test_fetchCases_returnsUnparseableErrorForWrongJSON() throws {
        let (sut, networkManager) = makeSUT()

        let data = try JSONSerialization.data(withJSONObject: anyJSONObject())
        let exp = expectation(description: #function)
        var receivedResult: Result<Timeline, WebserviceError>?
        let expectedResult: Result<Timeline, WebserviceError> = .failure(.unparseable)
        sut.fetchCases { result in
            receivedResult = result
            exp.fulfill()
        }
        networkManager.complete(with: .success(data))
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(expectedResult, receivedResult)
    }

    func test_fetchCases_returnsCorrectErrorForFailure() throws {
        let (sut, networkManager) = makeSUT()

        let exp = expectation(description: #function)
        var receivedResult: Result<Timeline, WebserviceError>?
        let expectedResult: Result<Timeline, WebserviceError> = .failure(.internalServerError)
        sut.fetchCases { result in
            receivedResult = result
            exp.fulfill()
        }
        networkManager.complete(with: .failure(.internalServerError))
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(expectedResult, receivedResult)
    }
}

extension WorldServiceTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (WorldService, NetworkManagerSpy) {
        let networkManager = NetworkManagerSpy()
        let service = WorldService(networkManager: networkManager)

        checkMemoryLeak(for: networkManager, file: file, line: line)
        checkMemoryLeak(for: service, file: file, line: line)

        return (service, networkManager)
    }
}
