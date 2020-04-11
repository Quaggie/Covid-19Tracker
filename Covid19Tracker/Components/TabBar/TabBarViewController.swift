//
//  TabBarViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBar.isOpaque = true
        tabBar.backgroundColor = Color.white

        let countryViewController = CountryViewController()
        countryViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tabbar_home"), tag: 0)

        let worldViewController = WorldViewController()
        worldViewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)

        let newsViewController = NewsViewController()
        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 2)

        let careViewController = CareViewController()
        careViewController.tabBarItem = UITabBarItem(title: "Care", image: UIImage(named: "tabbar_care"), tag: 3)

        viewControllers = [countryViewController, worldViewController, newsViewController, careViewController]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
