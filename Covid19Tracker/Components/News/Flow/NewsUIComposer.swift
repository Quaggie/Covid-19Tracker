//
//  NewsUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import Data

final class NewsUIComposer: UIComposer {
    func compose() -> NewsViewController {
        let viewController = NewsViewController(newsService: MainQueueDispatchDecorator(instance: NewsService()))
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)
        return viewController
    }
}
