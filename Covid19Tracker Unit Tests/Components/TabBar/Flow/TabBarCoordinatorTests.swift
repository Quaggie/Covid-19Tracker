//
//  TabBarCoordinatorTests.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class TabBarCoordinatorTests: XCTestCase {
    func test_start_configureViewControllers() {
        let (_, tabBarViewController) = makeSUT()

        XCTAssertEqual(tabBarViewController.viewControllers?.count, 5)
    }

    func test_tabBarControllerShouldSelectViewController_shouldSelectAllButSearchViewController() {
        let (sut, tabBarViewController) = makeSUT()

        let shouldSelectViewController0 = sut.tabBarController(tabBarViewController, shouldSelect: tabBarViewController.viewControllers![0])
        XCTAssertTrue(shouldSelectViewController0)

        let shouldSelectViewController1 = sut.tabBarController(tabBarViewController, shouldSelect: tabBarViewController.viewControllers![1])
        XCTAssertTrue(shouldSelectViewController1)

        let shouldSelectViewController2 = sut.tabBarController(tabBarViewController, shouldSelect: tabBarViewController.viewControllers![2])
        XCTAssertFalse(shouldSelectViewController2)

        let shouldSelectViewController3 = sut.tabBarController(tabBarViewController, shouldSelect: tabBarViewController.viewControllers![3])
        XCTAssertTrue(shouldSelectViewController3)

        let shouldSelectViewController4 = sut.tabBarController(tabBarViewController, shouldSelect: tabBarViewController.viewControllers![4])
        XCTAssertTrue(shouldSelectViewController4)
    }
}

extension TabBarCoordinatorTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (TabBarCoordinator, TabBarViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = TabBarCoordinator(window: window)
        coordinator.start()
        let tabBarViewController = window.rootViewController as! TabBarViewController
        checkMemoryLeak(for: coordinator, file: file, line: line)
        checkMemoryLeak(for: tabBarViewController, file: file, line: line)
        defer {
            window.rootViewController = nil
        }
        return (coordinator, tabBarViewController)
    }
}
