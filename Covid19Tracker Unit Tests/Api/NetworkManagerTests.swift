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
        testRequest(source: .covid, urlPath: anyURLPath(), for: .get)
        testRequest(source: .google, urlPath: anyURLPath(), for: .get)
    }

    func test_fetch_requestsWithCorrectURLForPostMethod() {
        testRequest(source: .covid, urlPath: anyURLPath(), for: .post, with: anyDictionary())
        testRequest(source: .google, urlPath: anyURLPath(), for: .post, with: anyDictionary())
    }

    func test_fetch_failsWhenRequestCompletesWithAllErrorCases() {
        expect(.failure(.unexpected), when: .init(data: nil, response: nil, error: anyNSError()), for: anyURLPath())
        expect(.failure(.malformedURL), when: .init(data: nil, response: nil, error: anyNSError()), for: "\\wrongPath")
    }

    func test_fetch_shouldFailWithAllInvalidCases() {
        expect(.failure(.unexpected), when: .init(data: nil, response: nil, error: nil), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: anyData(), response: nil, error: nil), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: nil, response: anyURLResponse(), error: nil), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: nil, response: anyHTTPURLResponse(), error: nil), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: nil, response: anyHTTPURLResponse(), error: anyNSError()), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: anyData(), response: nil, error: anyNSError()), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyURLResponse(), error: nil), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()), for: anyURLPath())
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyURLResponse(), error: anyNSError()), for: anyURLPath())
    }
}

extension NetworkManagerTests {
    func makeSUT(source: NetworkManager.Source = .covid) -> NetworkManager {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]

        let networkManager = NetworkManager(source: source, sessionConfiguration: configuration)
        checkMemoryLeak(for: networkManager)
        return networkManager
    }

    func testRequest(source: NetworkManager.Source, urlPath: String, for method: HTTPMethod, with parameters: [String: Any] = [:], file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT(source: source)
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

    func expect(_ expectedResult: Result<Data, WebserviceError>, when stub: Stub, for urlPath: String, file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()
        var receivedResult: Result<Data, WebserviceError>?

        let expectation = expectation(description: #function)
        URLProtocolStub.stub(stub)
        sut.fetch(urlString: urlPath, method: .get, parameters: [:], headers: [:]) { result in
            receivedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        switch (expectedResult, receivedResult) {
        case (.success(let expectedData), .success(let receivedData)):
            XCTAssertEqual(receivedData, expectedData)
        case (.failure(let expectedError), .failure(let receivedError)):
            XCTAssertEqual(expectedError, receivedError)
        default:
            switch (expectedResult, receivedResult) {
            case (.success(let expectedData), .success(let receivedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) got \(String(describing: receivedResult)) instead")
            }
        }
    }

    func anyURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: "")
    }

    func anyHTTPURLResponse(statusCode: Int = 0) -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: "", headerFields: nil)!
    }
}
