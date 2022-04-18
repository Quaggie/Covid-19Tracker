//
//  CareCoordinatorTests.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class CareCoordinatorTests: XCTestCase {
    func test_rootViewController_isCareViewController() {
        let (_, viewControllerPresenter) = makeSUT()

        XCTAssertEqual(viewControllerPresenter.viewControllers.count, 1)
        XCTAssert(viewControllerPresenter.viewControllers[0] is CareViewController)
    }
}

extension CareCoordinatorTests {
    func makeSUT() -> (CareCoordinator, ViewControllerPresenterSpy) {
        let viewControllerPresenter = ViewControllerPresenterSpy()
        let coordinator = CareCoordinator(parent: viewControllerPresenter)
        checkMemoryLeak(for: coordinator)
        checkMemoryLeak(for: viewControllerPresenter)
        coordinator.start()
        return (coordinator, viewControllerPresenter)
    }
}
