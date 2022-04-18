//
//  MainCoordinatorTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class MainCoordinatorTests: XCTestCase {
    func test_start_shouldShowTabBarViewController() {
        let (_, window) = makeSUT()

        XCTAssert(window.rootViewController is TabBarViewController)
    }
}

extension MainCoordinatorTests {
    func makeSUT() -> (MainCoordinator, UIWindow) {
        let window = UIWindow()
        let coordinator = MainCoordinator(window: window)
        checkMemoryLeak(for: coordinator)
        checkMemoryLeak(for: window)
        coordinator.start()
        return (coordinator, window)
    }
}
