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
        let sut = makeSut()

        XCTAssertEqual(sut.viewControllers?.count, 5)
        XCTAssertTrue(sut.tabBar.isOpaque)
        XCTAssertEqual(sut.tabBar.backgroundColor, Color.white)
        XCTAssertNotNil(sut.delegate)
    }

    func test_tabViewControllerShouldViewController_shouldSelectOnlyIfMiddleViewControllerIsGiven() {
        let sut = makeSut()

        let shouldSelect = { (viewController: UIViewController) -> Bool in
            return sut.tabBarController(sut, shouldSelect: viewController)
        }
        XCTAssertTrue(shouldSelect(sut.viewControllers![0]))
        XCTAssertTrue(shouldSelect(sut.viewControllers![1]))
        XCTAssertFalse(shouldSelect(sut.viewControllers![2]))
        XCTAssertTrue(shouldSelect(sut.viewControllers![3]))
        XCTAssertTrue(shouldSelect(sut.viewControllers![4]))
    }
}

extension TabBarViewControllerTests {
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> TabBarViewController {
        let sut = TabBarViewController()
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
