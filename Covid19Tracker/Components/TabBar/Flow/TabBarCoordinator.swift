//
//  TabBarCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

protocol TabBarCoordinatorDelegate: AnyObject {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
}

final class TabBarCoordinator: Coordinator {
    private let window: UIWindow

    private let composers: [() -> UIViewController] = [
        HomeUIComposer().compose,
        WorldUIComposer().compose,
        SearchUIComposer(cameFromHome: false).compose,
        NewsUIComposer().compose,
        CareUIComposer().compose
    ]

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewControllers = composers.map { $0() }
        window.rootViewController = TabBarUIComposer(coordinator: self, viewControllers: viewControllers).compose()
    }
}

// MARK: - TabBarCoordinatorDelegate
extension TabBarCoordinator: TabBarCoordinatorDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let coordinator = SearchCoordinator(viewController: tabBarController, cameFromHome: false)
            coordinator.start()
            return false
        }

        return true
    }
}
