//
//  SearchUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

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
