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
        let networkManager = NetworkManagerSpy()
        let sut = WorldService(networkManager: networkManager)
        checkMemoryLeak(for: networkManager)
        checkMemoryLeak(for: sut)

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
}

final class NetworkManagerSpy: NetworkManagerProtocol {
    var fetchCompletionMessages: [(Result<Data, WebserviceError>) -> Void] = []

    func fetch(urlString: String, method: HTTPMethod, parameters: [String : Any], headers: [String : String], completion: @escaping (Result<Data, WebserviceError>) -> Void) {
        fetchCompletionMessages.append(completion)
    }

    func complete(with result: Result<Data, WebserviceError>, at index: Int = 0) {
        fetchCompletionMessages[index](result)
    }
}
