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

    init(coordinator: TabBarCoordinatorDelegate) {
        self.coordinator = coordinator
    }

    func compose() -> UITabBarController {
        TabBarViewController(coordinator: coordinator)
    }
}
