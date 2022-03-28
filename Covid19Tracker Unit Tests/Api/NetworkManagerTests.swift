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
        testRequest(urlPath: anyURLPath(), for: .get)
    }

    func test_fetch_requestsWithCorrectURLForPostMethod() {
        testRequest(urlPath: anyURLPath(), for: .post, with: anyDictionary())
    }

    func test_fetch_failsWhenRequestCompletesWithError() {
        let sut = makeSUT()
        var receivedResult: Result<Data, WebserviceError>?

        let expectedResult = Result<Data, WebserviceError>.failure(.internalServerError)
        let expectation = expectation(description: "Waiting for request")
        URLProtocolStub.stub(.init(data: nil, response: nil, error: anyNSError()))
        sut.fetch(urlString: anyURLPath(), method: .get, parameters: [:], headers: [:]) { result in
            receivedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        switch (expectedResult, receivedResult) {
        case (.success(let expectedData), .success(let receivedData)):
            XCTAssertEqual(receivedData, expectedData)
        case (.failure(let expectedError), .failure(let receivedError)):
            XCTAssertEqual(expectedError, receivedError)
        default:
            XCTFail("Expected \(expectedResult) result got \(String(describing: receivedResult)) instead")
        }
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

    func testRequest(urlPath: String, for method: HTTPMethod, with parameters: [String: Any] = [:], file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()
        var receivedRequest: URLRequest?
        let expectation = expectation(description: #function)
        URLProtocolStub.observeRequest { receivedRequest = $0 }
        sut.fetch(urlString: urlPath, method: method, parameters: parameters, headers: [:]) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(receivedRequest!.url!.absoluteString.contains(urlPath))
        XCTAssertEqual(receivedRequest!.httpMethod, method.rawValue)
    }
}
