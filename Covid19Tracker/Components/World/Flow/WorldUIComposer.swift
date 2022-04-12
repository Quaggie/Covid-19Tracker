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
            worldService: MainQueueDispatchDecorator(instance: WorldService()),
            countryService: MainQueueDispatchDecorator(instance: CountryService()),
            historicalInfoService: MainQueueDispatchDecorator(instance: HistoricalInfoService())
        )
        viewController.tabBarItem = UITabBarItem(title: "World", image: UIImage(named: "tabbar_world"), tag: 1)
        return viewController
    }
}
