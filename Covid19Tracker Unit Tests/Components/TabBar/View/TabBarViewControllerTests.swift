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
        let (sut, _) = makeSut()

        XCTAssertTrue(sut.tabBar.isOpaque)
        XCTAssertEqual(sut.tabBar.backgroundColor, Color.white)
        XCTAssertNotNil(sut.delegate)
    }

    func test_tabViewControllerShouldViewController_shouldSelectOnlyIfMiddleViewControllerIsGiven() {
        let (sut, coordinator) = makeSut()

        _ = sut.tabBarController(sut, shouldSelect: sut.viewControllers![0])
        XCTAssertEqual(coordinator.viewControllers, [sut.viewControllers![0]])

        _ = sut.tabBarController(sut, shouldSelect: sut.viewControllers![1])
        XCTAssertEqual(coordinator.viewControllers, [sut.viewControllers![0], sut.viewControllers![1]])

        _ = sut.tabBarController(sut, shouldSelect: sut.viewControllers![2])
        XCTAssertEqual(coordinator.viewControllers, [sut.viewControllers![0], sut.viewControllers![1], sut.viewControllers![2]])
    }
}

extension TabBarViewControllerTests {
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (TabBarViewController, TabBarCoordinatorSpy) {
        let coordinator = TabBarCoordinatorSpy()
        let viewController = TabBarViewController(coordinator: coordinator)
        viewController.setViewControllers([UIViewController(), UIViewController(), UIViewController()], animated: false)
        checkMemoryLeak(for: viewController, file: file, line: line)
        checkMemoryLeak(for: coordinator, file: file, line: line)
        return (viewController, coordinator)
    }
}

private class TabBarCoordinatorSpy: TabBarCoordinatorDelegate {
    var viewControllers: [UIViewController] = []

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        viewControllers.append(viewController)
        return true
    }
}
