//
//  SearchCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class SearchCoordinator: Coordinator {
    private let viewController: ViewControllerPresenter
    private let cameFromHome: Bool

    init(viewController: ViewControllerPresenter, cameFromHome: Bool) {
        self.viewController = viewController
        self.cameFromHome = cameFromHome
        print("[SearchCoordinator] initialized!")
    }

    func start() {
        let vc = SearchUIComposer(cameFromHome: cameFromHome).compose()
        viewController.show(vc, sender: self)
    }

    deinit {
        print("[SearchCoordinator] deinitialized!")
    }
}
