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
            XCTAssertEqual((sut.observers.allObjects[0] as! ExampleObject).changeCount, 0)
            XCTAssertEqual((sut.observers.allObjects[1] as! ExampleObject).changeCount, 0)

            object2 = nil
        }
        XCTAssertNil(object1.otherObject)
        sut.pageSelectorViewDidChange(index: 0)

        XCTAssertTrue(sut.observers.contains(object1))
        XCTAssertFalse(sut.observers.contains(object1.otherObject))
        XCTAssertEqual((sut.observers.allObjects[0] as! ExampleObject).changeCount, 1)
        XCTAssertEqual(sut.observers.allObjects.count, 1)
    }
}

extension PageSelectorDelegatesObserverTests {
    func makeSUT() -> PageSelectorDelegatesObserver {
        PageSelectorDelegatesObserver()
    }
}

private class ExampleObject: NSObject, PageSelectorDelegate {
    weak var otherObject: ExampleObject?
    var changeCount = 0

    func pageSelectorDidChange(index: Int) {
        changeCount += 1
    }
}
