//
//  ConnectionErrorTests.swift
//  DataTests
//
//  Created by Jonathan Bijos on 08/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
import Networking
@testable import Data

class ConnectionErrorTests: XCTestCase {
    func test_conversionFromNetworkError_returnsCorrectTypes() {
        XCTAssertEqual(ConnectionError.from(networkError: .internalServerError), .internalServerError)
        XCTAssertEqual(ConnectionError.from(networkError: .notConnectedToInternet), .notConnectedToInternet)
        XCTAssertEqual(ConnectionError.from(networkError: .timedOut), .timedOut)
        XCTAssertEqual(ConnectionError.from(networkError: .unexpected), .unexpected)
        XCTAssertEqual(ConnectionError.from(networkError: .badRequest), .badRequest)
        XCTAssertEqual(ConnectionError.from(networkError: .unauthorized), .unauthorized)
        XCTAssertEqual(ConnectionError.from(networkError: .malformedURL), .malformedURL)
        XCTAssertEqual(ConnectionError.from(networkError: .unparseable), .unparseable)
        XCTAssertEqual(ConnectionError.from(networkError: .forbidden), .forbidden)
        XCTAssertEqual(ConnectionError.from(networkError: .preconditionFailed), .preconditionFailed)
        XCTAssertEqual(ConnectionError.from(networkError: .notFound), .notFound)
        XCTAssertEqual(ConnectionError.from(networkError: .conflict), .conflict)
        XCTAssertEqual(ConnectionError.from(networkError: .invalidResponse), .invalidResponse)
    }
}
