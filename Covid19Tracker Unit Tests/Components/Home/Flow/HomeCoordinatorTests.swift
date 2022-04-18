//
//  HomeCoordinatorTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class HomeCoordinatorTests: XCTestCase {
    func test_rootViewController_isHomeViewController() {
        let (_, viewControllerPresenter) = makeSUT()

        XCTAssertEqual(viewControllerPresenter.viewControllers.count, 1)
        XCTAssert(viewControllerPresenter.viewControllers[0] is HomeViewController)
    }
}

extension HomeCoordinatorTests {
    func makeSUT() -> (HomeCoordinator, ViewControllerPresenterSpy) {
        let viewControllerPresenter = ViewControllerPresenterSpy()
        let coordinator = HomeCoordinator(parent: viewControllerPresenter)
        checkMemoryLeak(for: coordinator)
        checkMemoryLeak(for: viewControllerPresenter)
        coordinator.start()
        return (coordinator, viewControllerPresenter)
    }
}
