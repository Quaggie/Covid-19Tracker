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
        let presenter = NewsPresenter(newsFetcher: MainQueueDispatchDecorator(instance: NewsService()))
        let dataSource = NewsDataSource()
        let delegateFlowLayout = NewsDelegateFlowLayout()
        let newsLoaderDelegatesComposite = NewsLoaderDelegatesComposite()
        newsLoaderDelegatesComposite.addDelegate(dataSource)
        newsLoaderDelegatesComposite.addDelegate(delegateFlowLayout)
        let viewController = NewsViewController(
            delegate: NewsTrackerAdapter(),
            presenter: presenter,
            dataSource: dataSource,
            delegateFlowLayout: delegateFlowLayout,
            newsLoader: newsLoaderDelegatesComposite
        )
        delegateFlowLayout.viewControllerPresenter = WeakRefVirtualProxy(viewController)
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "tabbar_news"), tag: 3)
        return viewController
    }
}
