//
//  MainQueueDispatchDecorator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class MainQueueDispatchDecoratorTests: XCTestCase {
    private var sut: MainQueueDispatchDecorator<FakeService>!

    override func setUp() {
        sut = MainQueueDispatchDecorator(instance: FakeService())
    }

    func test_dispatch_runsOnMainThreadWhenCalledFromMainThread() {
        let exp = expectation(description: #function)

        var isMainThread = false
        sut.example {
            isMainThread = Thread.isMainThread
            exp.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(isMainThread)
        }
    }

    func test_dispatch_runsOnMainThreadWhenCalledFromBackgroundThread() {
        let exp = expectation(description: #function)

        var isMainThread = false
        DispatchQueue.global(qos: .userInitiated).async {
            self.sut.example {
                isMainThread = Thread.isMainThread
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(isMainThread)
        }
    }
}

private protocol FakeServiceProtocol {
    func example(completion: @escaping () -> Void)
}

private class FakeService: FakeServiceProtocol {
    func example(completion: @escaping () -> Void) {
        completion()
    }
}

extension MainQueueDispatchDecorator: FakeServiceProtocol where T: FakeServiceProtocol {
    func example(completion: @escaping () -> Void) {
        instance.example {
            self.dispatch {
                completion()
            }
        }
    }
}
