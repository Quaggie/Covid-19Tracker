//
//  MainCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let window: UIWindow
    private let coordinator: Coordinator

    init(window: UIWindow) {
        self.window = window
        self.coordinator = TabBarCoordinator(window: window)
    }

    func start() {
        coordinator.start()
    }
}
