//
//  TabBarViewControllerTests.swift
//  TabBarViewControllerTests
//
//  Created by Jonathan Bijos on 24/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class TabBarViewControllerTests: XCTestCase {
    func test_init_configureViewControllers() {
        let sut = TabBarViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(sut.viewControllers?.count, 5)
    }
}
