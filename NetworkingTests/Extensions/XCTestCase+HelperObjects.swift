//
//  XCTestCase+HelperObjects.swift
//  NetworkTests
//
//  Created by Jonathan Bijos on 01/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest

extension XCTestCase {
    func anyDictionary() -> [String: Any] {
        ["Test Value": 1]
    }

    func anyNSError() -> NSError {
        NSError(domain: "Test", code: 100, userInfo: nil)
    }

    func anyData() -> Data {
        "Test Data".data(using: .utf8)!
    }

    func anyURL() -> URL {
        URL(string: "https://test.com")!
    }
}
