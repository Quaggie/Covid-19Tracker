//
//  WorldUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

final class WorldUIComposer: UIComposer {
    func compose() -> WorldViewController {
        let viewController = WorldViewController(
            worldFetcher: MainQueueDispatchDecorator(instance: WorldService()),
            countryFetcher: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoFetcher: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        viewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)
        return viewController
    }
}
