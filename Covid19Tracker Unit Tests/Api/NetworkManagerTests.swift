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
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]

        let sut = NetworkManager(sessionConfiguration: configuration)
        checkMemoryLeak(for: sut)

        var receivedRequest: URLRequest?

        let expectation = expectation(description: #function)
        URLProtocolStub.observeRequest { receivedRequest = $0 }
        sut.fetch(urlString: "www.google.com", method: .get, parameters: [:], headers: [:]) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(receivedRequest!.url!.absoluteString.contains("www.google.com"))
        XCTAssertEqual(receivedRequest?.httpMethod, HTTPMethod.get.rawValue)
    }
}

struct Stub {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

final class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?

    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObserver {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }

        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        }

        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        URLProtocolStub.requestObserver = nil
    }

    static func observeRequest(with observer: @escaping (URLRequest) -> Void) {
        URLProtocolStub.requestObserver = observer
    }

    static func stub(_ stub: Stub) {
        URLProtocolStub.stub = stub
    }
}
