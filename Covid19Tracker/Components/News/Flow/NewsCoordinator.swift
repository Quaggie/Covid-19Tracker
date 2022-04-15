//
//  NewsCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import SafariServices

protocol NewsCoordinatorDelegate: URLOpener {}

final class NewsCoordinator: Coordinator {
    private let parent: ViewControllerPresenter
    private lazy var rootViewController = NewsUIComposer(coordinator: self).compose()

    init(parent: ViewControllerPresenter) {
        self.parent = parent
        print("[NewsCoordinator] initialized!")
    }

    func start() {
        parent.show(rootViewController, sender: self)
    }

    deinit {
        print("[NewsCoordinator] deinitialized!")
    }
}

extension NewsCoordinator: NewsCoordinatorDelegate {
    func open(url: URL) {
        let controller = SFSafariViewController(url: url)
        rootViewController.show(controller, sender: self)
    }
}

extension WeakRefVirtualProxy: NewsCoordinatorDelegate where T: NewsCoordinatorDelegate {}
