//
//  HomeUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

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
