//
//  HomeCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

protocol HomeCoordinatorDelegate {
    func changeCountry()
}

final class HomeCoordinator: Coordinator {
    private let parent: ViewControllerPresenter
    private lazy var rootViewController = HomeUIComposer(coordinator: WeakRefVirtualProxy(self)).compose()

    init(parent: ViewControllerPresenter) {
        self.parent = parent
        print("[HomeCoordinator] initialized!")
    }

    func start() {
        parent.show(rootViewController, sender: self)
    }

    deinit {
        print("[HomeCoordinator] deinitialized!")
    }
}

// MARK: - HomeCoordinatorDelegate
extension HomeCoordinator: HomeCoordinatorDelegate {
    func changeCountry() {
        let coordinator = SearchCoordinator(parent: WeakRefVirtualProxy(rootViewController), cameFromHome: true)
        coordinator.start()
    }
}

extension WeakRefVirtualProxy: HomeCoordinatorDelegate where T: HomeCoordinatorDelegate {
    func changeCountry() {
        object?.changeCountry()
    }
}
