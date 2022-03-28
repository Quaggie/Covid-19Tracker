//
//  XCTestCase+HelperObjects.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 27/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest

extension XCTestCase {
    func anyJSONObject() -> [String: Any] {
        [:]
    }

    func anyURL() -> URL {
        URL(string: "https://test.com/")!
    }

    func anyDictionary() -> [String: Any] {
        ["Test Value": 1]
    }

    func anyNSError() -> NSError {
        return NSError(domain: "Test", code: 100, userInfo: nil)
    }
}
