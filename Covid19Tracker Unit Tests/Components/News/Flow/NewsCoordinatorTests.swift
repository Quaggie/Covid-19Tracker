//
//  NewsCoordinatorTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker
import SafariServices

class NewsCoordinatorTests: XCTestCase {
    func test_rootViewController_isNewsViewController() {
        let viewControllerPresenter = ViewControllerPresenterSpy()
        let sut = NewsCoordinator(parent: viewControllerPresenter)
        sut.start()

        XCTAssertEqual(viewControllerPresenter.viewControllers.count, 1)
        XCTAssert(viewControllerPresenter.viewControllers[0] is NewsViewController)
    }
}
