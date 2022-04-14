//
//  NewsUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

final class NewsUIComposer: UIComposer {
    func compose() -> NewsViewController {
        let presenter = NewsPresenter(newsService: MainQueueDispatchDecorator(instance: NewsService()))
        let viewController = NewsViewController(
            delegate: NewsTrackerAdapter(),
            presenter: presenter
        )
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)
        return viewController
    }
}
