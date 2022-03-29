//
//  TabBarViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        tabBar.isOpaque = true
        tabBar.backgroundColor = Color.white
        delegate = self

        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tabbar_home"), tag: 0)

        let worldViewController = WorldViewController(
            worldService: MainQueueDispatchDecorator(instance: WorldService()),
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        worldViewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)

        let searchViewController = makeSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search_icon"), tag: 2)

        let newsViewController = NewsViewController(newsService: MainQueueDispatchDecorator(instance: NewsService()))
        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)

        let careViewController = CareViewController()
        careViewController.tabBarItem = UITabBarItem(title: "Care", image: UIImage(named: "tabbar_care"), tag: 4)

        viewControllers = [homeViewController, worldViewController, searchViewController, newsViewController, careViewController]
    }

    private func makeSearchViewController() -> SearchViewController {
        SearchViewController(cameFromHome: false, countryService: MainQueueDispatchDecorator(instance: CountryService()))
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SearchViewController {
            let controller = makeSearchViewController()
            present(controller, animated: true)
            return false
        }

        return true
    }
}
