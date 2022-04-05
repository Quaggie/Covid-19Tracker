//
//  CareCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import Data

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private let coordinator: Coordinator

    private let composers: [() -> UIViewController] = [
        HomeUIComposer().compose,
        WorldUIComposer().compose,
        SearchUIComposer(cameFromHome: false).compose,
        NewsUIComposer().compose,
        CareUIComposer().compose
    ]

    init(window: UIWindow, coordinator: Coordinator? = nil) {
        self.window = window
        let viewControllers = composers.map { $0() }
        self.coordinator = coordinator ?? TabBarCoordinator(window: window, viewControllers: viewControllers)
    }

    func start() {
        coordinator.start()
    }
}

protocol TabBarCoordinatorDelegate: AnyObject {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
}

final class TabBarCoordinator: Coordinator {
    private let window: UIWindow
    private let viewControllers: [UIViewController]

    init(window: UIWindow, viewControllers: [UIViewController]) {
        self.window = window
        self.viewControllers = viewControllers
    }

    func start() {
        window.rootViewController = TabBarUIComposer(coordinator: self, viewControllers: viewControllers).compose()
    }
}

// MARK: - TabBarCoordinatorDelegate
extension TabBarCoordinator: TabBarCoordinatorDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SearchViewController {
            let coordinator = SearchCoordinator(viewController: tabBarController, cameFromHome: false)
            coordinator.start()
            return false
        }

        return true
    }
}

final class SearchCoordinator: Coordinator {
    private let viewController: ViewControllerPresenter
    private let cameFromHome: Bool

    init(viewController: ViewControllerPresenter, cameFromHome: Bool) {
        self.viewController = viewController
        self.cameFromHome = cameFromHome
        print("[SearchCoordinator] initialized!")
    }

    func start() {
        let vc = SearchUIComposer(cameFromHome: cameFromHome).compose()
        viewController.show(vc, sender: self)
    }

    deinit {
        print("[SearchCoordinator] deinitialized!")
    }
}

final class CareCoordinator: Coordinator {
    func start() {

    }
}

final class HomeUIComposer: UIComposer {
    func compose() -> HomeViewController {
        let viewController = HomeViewController(
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tabbar_home"), tag: 0)
        return viewController
    }
}

final class WorldUIComposer: UIComposer {
    func compose() -> WorldViewController {
        let viewController = WorldViewController(
            worldService: MainQueueDispatchDecorator(instance: WorldService()),
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        viewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)
        return viewController
    }
}

final class SearchUIComposer: UIComposer {
    private let cameFromHome: Bool

    init(cameFromHome: Bool) {
        self.cameFromHome = cameFromHome
    }

    func compose() -> SearchViewController {
        let viewController = SearchViewController(
            cameFromHome: cameFromHome,
            countryService: MainQueueDispatchDecorator(instance: CountryService())
        )
        viewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search_icon"), tag: 2)
        return viewController
    }
}

final class NewsUIComposer: UIComposer {
    func compose() -> NewsViewController {
        let viewController = NewsViewController(newsService: MainQueueDispatchDecorator(instance: NewsService()))
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)
        return viewController
    }
}

final class TabBarUIComposer: UIComposer {
    private let coordinator: TabBarCoordinatorDelegate
    private let viewControllers: [UIViewController]

    init(coordinator: TabBarCoordinatorDelegate, viewControllers: [UIViewController]) {
        self.coordinator = coordinator
        self.viewControllers = viewControllers
    }

    func compose() -> UITabBarController {
        let viewController = TabBarViewController(coordinator: coordinator)
        viewController.viewControllers = viewControllers
        return viewController
    }
}
