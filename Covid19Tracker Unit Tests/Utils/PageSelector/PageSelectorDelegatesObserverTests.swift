//
//  PageSelectorDelegatesObserver.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

final class PageSelectorDelegatesObserverTests: XCTestCase {
    func test_delegatesAreRemovedFromArrayOnDeinit() {
        let object1 = ExampleObject()
        var object2: ExampleObject?

        object2 = ExampleObject()
        object1.otherObject = object2
        let sut = makeSUT()
        checkMemoryLeak(for: sut)

        autoreleasepool {
            sut.addListener(object1)
            sut.addListener(object1.otherObject!)

            XCTAssertEqual(sut.observers.count, 2)
            XCTAssertEqual((sut.observers.allObjects[0] as! ExampleObject).indexes, [])
            XCTAssertEqual((sut.observers.allObjects[1] as! ExampleObject).indexes, [])

            object2 = nil
        }
        XCTAssertNil(object1.otherObject)
        sut.pageSelectorViewDidChange(index: 0)

        XCTAssertTrue(sut.observers.contains(object1))
        XCTAssertFalse(sut.observers.contains(object1.otherObject))
        XCTAssertEqual((sut.observers.allObjects[0] as! ExampleObject).indexes, [0])
        XCTAssertEqual(sut.observers.allObjects.count, 1)
    }

    func test_pageSelectorViewDidChange_notifiesAllObservers() {
        let sut = makeSUT()
        let object1 = ExampleObject()
        let object2 = ExampleObject()
        let object3 = ExampleObject()

        sut.addListener(object1)

        sut.pageSelectorViewDidChange(index: 0)
        XCTAssertEqual(object1.indexes, [0])
        XCTAssertEqual(object2.indexes, [])
        XCTAssertEqual(object3.indexes, [])

        sut.addListener(object2)

        sut.pageSelectorViewDidChange(index: 1)
        XCTAssertEqual(object1.indexes, [0, 1])
        XCTAssertEqual(object2.indexes, [1])
        XCTAssertEqual(object3.indexes, [])

        sut.addListener(object3)

        sut.pageSelectorViewDidChange(index: 1)
        XCTAssertEqual(object1.indexes, [0, 1, 1])
        XCTAssertEqual(object2.indexes, [1, 1])
        XCTAssertEqual(object3.indexes, [1])
    }
}

extension PageSelectorDelegatesObserverTests {
    func makeSUT() -> PageSelectorDelegatesObserver {
        PageSelectorDelegatesObserver()
    }
}

private class ExampleObject: NSObject, PageSelectorDelegate {
    weak var otherObject: ExampleObject?
    var indexes: [Int] = []

    func pageSelectorDidChange(index: Int) {
        indexes.append(index)
    }
}
