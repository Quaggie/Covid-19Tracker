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
    static let validURLPath = "/test"
    static let invalidURLPath = "\\test"

    override func setUp() {
        URLProtocolStub.startIntercepting()
    }

    override func tearDown() {
        URLProtocolStub.stopIntercepting()
    }

    func test_fetch_requestsWithCorrectURLForGetMethod() {
        testRequest(source: .covid, urlPath: Self.validURLPath, for: .get)
        testRequest(source: .google, urlPath: Self.validURLPath, for: .get)
    }

    func test_fetch_requestsWithCorrectURLForPostMethod() {
        testRequest(source: .covid, urlPath: Self.validURLPath, for: .post, with: anyDictionary(), and: anyHeader())
        testRequest(source: .google, urlPath: Self.validURLPath, for: .post, with: anyDictionary(), and: anyHeader())
    }

    func test_fetch_failsWhenRequestCompletesWithAllErrorCases() {
        expect(.failure(.unexpected), when: .init(data: nil, response: nil, error: anyNSError()), for: Self.validURLPath)
        expect(.failure(.malformedURL), when: .init(data: nil, response: nil, error: anyNSError()), for: Self.invalidURLPath)
        expect(.failure(.timedOut), when: .init(data: nil, response: nil, error: URLError(.timedOut, userInfo: [:])))
        expect(.failure(.notConnectedToInternet), when: .init(data: nil, response: nil, error: URLError(.notConnectedToInternet, userInfo: [:])))
        expect(.failure(.unexpected), when: .init(data: nil, response: nil, error: URLError(.badServerResponse, userInfo: [:])))
    }

    func test_fetch_shouldFailWithAllInvalidCases() {
        expect(.failure(.unexpected), when: .init(data: nil, response: nil, error: nil))
        expect(.failure(.unexpected), when: .init(data: anyData(), response: nil, error: nil))
        expect(.failure(.unexpected), when: .init(data: nil, response: anyURLResponse(), error: nil))
        expect(.failure(.unexpected), when: .init(data: nil, response: anyHTTPURLResponse(), error: nil))
        expect(.failure(.unexpected), when: .init(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        expect(.failure(.unexpected), when: .init(data: anyData(), response: nil, error: anyNSError()))
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyURLResponse(), error: nil))
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        expect(.failure(.unexpected), when: .init(data: anyData(), response: anyURLResponse(), error: anyNSError()))
    }

    func test_fetch_FailsIfRequestCompletesWithNon200Status() {
        let data = anyData()
        expect(.failure(.internalServerError), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 500), error: nil))
        expect(.failure(.badRequest), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 400), error: nil))
        expect(.failure(.unauthorized), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 401), error: nil))
        expect(.failure(.forbidden), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 403), error: nil))
        expect(.failure(.notFound), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 404), error: nil))
        expect(.failure(.preconditionFailed), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 412), error: nil))
        expect(.failure(.conflict), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 409), error: nil))
        expect(.failure(.unexpected), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 499), error: nil))
        expect(.failure(.unexpected), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 600), error: nil))
    }

    func test_fetch_succeedsWithValidResponseAndData() {
        let data = anyData()
        expect(.success(data), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 200), error: nil))
    }

    func test_fetch_succeedsWithEmptyData() {
        let data = Data()
        expect(.success(data), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 200), error: nil))
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

    func testRequest(source: NetworkManager.Source, urlPath: String, for method: HTTPMethod, with parameters: [String: Any] = [:], and headers: [String: String] = [:], file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT(source: source)
        var receivedRequest: URLRequest?
        let expectation = expectation(description: #function)
        URLProtocolStub.observeRequest { receivedRequest = $0 }
        sut.fetch(urlString: urlPath, method: method, parameters: parameters, headers: headers) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(receivedRequest!.url!.absoluteString.contains(urlPath))
        XCTAssertEqual(receivedRequest!.httpMethod, method.rawValue)
    }

    func expect(_ expectedResult: Result<Data, WebserviceError>, when stub: Stub, for urlPath: String = NetworkManagerTests.validURLPath, file: StaticString = #filePath, line: UInt = #line) {
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
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let expectedError), .failure(let receivedError)):
            XCTAssertEqual(expectedError, receivedError, file: file, line: line)
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

    func anyHeader() -> [String: String] {
        ["Test": "123"]
    }

    func anyURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: "")
    }

    func anyHTTPURLResponse(statusCode: Int = 0) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: "", headerFields: nil)!
    }
}
