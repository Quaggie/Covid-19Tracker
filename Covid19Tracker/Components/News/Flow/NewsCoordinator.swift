//
//  NewsCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class NewsCoordinator: Coordinator {
    private let viewController: ViewControllerPresenter

    init(viewController: ViewControllerPresenter) {
        self.viewController = viewController
        print("[NewsCoordinator] initialized!")
    }

    func start() {
        let vc = NewsUIComposer().compose()
        viewController.show(vc, sender: self)
    }

    deinit {
        print("[NewsCoordinator] deinitialized!")
    }
}
