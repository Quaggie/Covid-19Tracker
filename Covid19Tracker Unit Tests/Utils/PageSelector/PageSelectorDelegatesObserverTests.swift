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
    func test_delegatesAreDeallocatedOnDeinit() {
        var sut: PageSelectorDelegatesComposite? = makeSUT()
        let object1 = ExampleObject()
        let object2 = ExampleObject()
        checkMemoryLeak(for: object1)
        checkMemoryLeak(for: object2)

        sut?.addDelegate(object1)
        sut?.addDelegate(object2)
        XCTAssertEqual(sut!.delegates.count, 2)
        XCTAssertEqual((sut!.delegates.allObjects[0] as! ExampleObject).indexes, [])
        XCTAssertEqual((sut!.delegates.allObjects[1] as! ExampleObject).indexes, [])
        sut = nil
    }

    func test_delegatesAreRemovedFromArrayOnTheirDeinit() {
        let object1 = ExampleObject()
        var object2: ExampleObject?

        object2 = ExampleObject()
        object1.otherObject = object2
        let sut = makeSUT()

        autoreleasepool {
            sut.addDelegate(object1)
            sut.addDelegate(object1.otherObject!)

            XCTAssertEqual(sut.delegates.count, 2)
            XCTAssertEqual((sut.delegates.allObjects[0] as! ExampleObject).indexes, [])
            XCTAssertEqual((sut.delegates.allObjects[1] as! ExampleObject).indexes, [])

            object2 = nil
        }
        XCTAssertNil(object1.otherObject)
        sut.pageSelectorViewDidChange(index: 0)

        XCTAssertTrue(sut.delegates.contains(object1))
        XCTAssertFalse(sut.delegates.contains(object1.otherObject))
        XCTAssertEqual((sut.delegates.allObjects[0] as! ExampleObject).indexes, [0])
        XCTAssertEqual(sut.delegates.allObjects.count, 1)
    }

    func test_pageSelectorViewDidChange_notifiesAllObserversInWhateverOrderAndAmount() {
        let sut = makeSUT()
        let object1 = ExampleObject()
        let object2 = ExampleObject()
        let object3 = ExampleObject()

        sut.addDelegate(object1)

        sut.pageSelectorViewDidChange(index: 0)
        XCTAssertEqual(object1.indexes, [0])
        XCTAssertEqual(object2.indexes, [])
        XCTAssertEqual(object3.indexes, [])

        sut.addDelegate(object2)

        sut.pageSelectorViewDidChange(index: 1)
        XCTAssertEqual(object1.indexes, [0, 1])
        XCTAssertEqual(object2.indexes, [1])
        XCTAssertEqual(object3.indexes, [])

        sut.addDelegate(object3)

        sut.pageSelectorViewDidChange(index: 1)
        XCTAssertEqual(object1.indexes, [0, 1, 1])
        XCTAssertEqual(object2.indexes, [1, 1])
        XCTAssertEqual(object3.indexes, [1])
    }
}

extension PageSelectorDelegatesObserverTests {
    func makeSUT() -> PageSelectorDelegatesComposite {
        let sut = PageSelectorDelegatesComposite()
        checkMemoryLeak(for: sut)
        return sut
    }
}

private class ExampleObject: NSObject, PageSelectorDelegate {
    weak var otherObject: ExampleObject?
    var indexes: [Int] = []

    func pageSelectorDidChange(index: Int) {
        indexes.append(index)
    }
}
