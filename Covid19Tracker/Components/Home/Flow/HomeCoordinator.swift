//
//  HomeCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class HomeCoordinator: Coordinator {
    private let viewController: ViewControllerPresenter

    init(viewController: ViewControllerPresenter) {
        self.viewController = viewController
        print("[HomeCoordinator] initialized!")
    }

    func start() {
        let vc = HomeUIComposer().compose()
        viewController.show(vc, sender: self)
    }

    deinit {
        print("[HomeCoordinator] deinitialized!")
    }
}
