//
//  NewsCoordinatorTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class NewsCoordinatorTests: XCTestCase {
    func test_rootViewController_isNewsViewController() {
        let (_, viewControllerPresenter) = makeSUT()

        XCTAssertEqual(viewControllerPresenter.viewControllers.count, 1)
        XCTAssert(viewControllerPresenter.viewControllers[0] is NewsViewController)
    }
}

extension NewsCoordinatorTests {
    func makeSUT() -> (NewsCoordinator, ViewControllerPresenterSpy) {
        let viewControllerPresenter = ViewControllerPresenterSpy()
        let coordinator = NewsCoordinator(parent: viewControllerPresenter)
        checkMemoryLeak(for: coordinator)
        checkMemoryLeak(for: viewControllerPresenter)
        coordinator.start()
        return (coordinator, viewControllerPresenter)
    }
}
