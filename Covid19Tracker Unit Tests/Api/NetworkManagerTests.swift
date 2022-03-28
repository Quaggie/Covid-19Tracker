//
//  NetworkManagerTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 28/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class NetworkManagerTests: XCTestCase {
    override func setUp() {
        URLProtocolStub.startIntercepting()
    }

    override func tearDown() {
        URLProtocolStub.stopIntercepting()
    }

    func test_fetch_requestsWithCorrectURLForGetMethod() {
        testRequest(url: anyURL(), for: .get)
    }

    func test_fetch_requestsWithCorrectURLForPostMethod() {
        testRequest(url: anyURL(), for: .post, with: anyDictionary())
    }
}

extension NetworkManagerTests {
    func makeSUT() -> NetworkManager {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]

        let networkManager = NetworkManager(sessionConfiguration: configuration)
        checkMemoryLeak(for: networkManager)
        return networkManager
    }

    func testRequest(url: URL, for method: HTTPMethod, with parameters: [String: Any] = [:], file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()
        var receivedRequest: URLRequest?
        let expectation = expectation(description: #function)
        URLProtocolStub.observeRequest { receivedRequest = $0 }
        sut.fetch(urlString: url.absoluteString, method: method, parameters: parameters, headers: [:]) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(receivedRequest!.url!.absoluteString.contains(url.absoluteString))
        XCTAssertEqual(receivedRequest!.httpMethod, method.rawValue)
    }
}
