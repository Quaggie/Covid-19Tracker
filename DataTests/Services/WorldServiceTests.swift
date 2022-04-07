//
//  WorldServiceTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 27/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
import Networking
@testable import Data

class WorldServiceTests: XCTestCase {
    func test_fetchCases_callsServiceOncePerExecution() {
        let (sut, networkManager) = makeSUT()

        sut.fetchCases { _ in }

        XCTAssertEqual(networkManager.messagesCount, 1)
    }

    func test_fetchCases_returnsTimelineOnSuccess() {
        let (sut, networkManager) = makeSUT()

        let timeline = TimelineModel(cases: 0, active: 0, deaths: 0, recovered: 0, todayCases: 0, todayDeaths: 0)
        expect(sut: sut, with: .success(timeline)) {
            let data = try! JSONEncoder().encode(timeline)
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCases_returnsUnparseableErrorForWrongJSON() {
        let (sut, networkManager) = makeSUT()

        expect(sut: sut, with: .failure(.unparseable)) {
            let data = try! JSONSerialization.data(withJSONObject: anyJSONObject())
            networkManager.complete(with: .success(data))
        }
    }

    func test_fetchCases_returnsCorrectErrorForFailure() {
        let (sut, networkManager) = makeSUT()

        expect(sut: sut, with: .failure(.internalServerError)) {
            networkManager.complete(with: .failure(.internalServerError))
        }
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

    func expect(sut: WorldService, with expectedResult: Result<TimelineModel, ConnectionError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: #function)
        var receivedResult: Result<TimelineModel, ConnectionError>?
        sut.fetchCases { result in
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
}
