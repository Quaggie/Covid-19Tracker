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

    init(window: UIWindow) {
        self.window = window
        print("[TabBarCoordinator] initialized!")
    }

    func start() {
        window.rootViewController = TabBarUIComposer(coordinator: WeakRefVirtualProxy(self)).compose()
        startCoordinators()
    }

    private func startCoordinators() {
        HomeCoordinator(parent: self).start()
        WorldCoordinator(viewController: self).start()
        SearchCoordinator(parent: self, cameFromHome: false).start()
        NewsCoordinator(parent: self).start()
        CareCoordinator(viewController: self).start()
    }

    deinit {
        print("[TabBarCoordinator] deinitialized!")
    }
}

// MARK: - TabBarCoordinatorDelegate
extension TabBarCoordinator: TabBarCoordinatorDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let coordinator = SearchCoordinator(parent: WeakRefVirtualProxy(tabBarController), cameFromHome: false)
            coordinator.start()
            return false
        }

        return true
    }
}

// MARK: - ViewControllerPresenter
extension TabBarCoordinator: ViewControllerPresenter {
    func show(_ vc: UIViewController, sender: Any?) {
        let tabBarViewController = window.rootViewController as? TabBarViewController
        if tabBarViewController?.viewControllers != nil {
            tabBarViewController?.viewControllers?.append(vc)
        } else {
            tabBarViewController?.viewControllers = [vc]
        }
    }
}

extension WeakRefVirtualProxy: TabBarCoordinatorDelegate where T: TabBarCoordinatorDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return object?.tabBarController(tabBarController, shouldSelect: viewController) ?? true
    }
}
