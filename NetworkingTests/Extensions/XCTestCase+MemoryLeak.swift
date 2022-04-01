//
//  XCTestCase+MemoryLeak.swift
//  NetworkTests
//
//  Created by Jonathan Bijos on 01/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line:  line)
        }
    }
}
