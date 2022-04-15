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
    private let coordinator: HomeCoordinatorDelegate

    init(coordinator: HomeCoordinatorDelegate) {
        self.coordinator = coordinator
    }

    func compose() -> HomeViewController {
        let viewController = HomeViewController(
            coordinator: coordinator,
            countryFetcher: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoFetcher: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tabbar_home"), tag: 0)
        return viewController
    }
}
