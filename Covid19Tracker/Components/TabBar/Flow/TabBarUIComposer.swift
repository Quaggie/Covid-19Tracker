//
//  TabBarUIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class TabBarUIComposer: UIComposer {
    private let coordinator: TabBarCoordinatorDelegate
    private let viewControllers: [UIViewController]

    init(coordinator: TabBarCoordinatorDelegate, viewControllers: [UIViewController]) {
        self.coordinator = coordinator
        self.viewControllers = viewControllers
    }

    func compose() -> UITabBarController {
        let viewController = TabBarViewController(coordinator: coordinator)
        viewController.viewControllers = viewControllers
        return viewController
    }
}
