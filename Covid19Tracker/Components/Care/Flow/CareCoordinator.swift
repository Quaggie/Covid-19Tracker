//
//  CareCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class CareCoordinator: Coordinator {
    private let viewController: ViewControllerPresenter

    init(viewController: ViewControllerPresenter) {
        self.viewController = viewController
        print("[CareCoordinator] initialized!")
    }

    func start() {
        let vc = CareUIComposer().compose()
        viewController.show(vc, sender: self)
    }

    deinit {
        print("[CareCoordinator] deinitialized!")
    }
}