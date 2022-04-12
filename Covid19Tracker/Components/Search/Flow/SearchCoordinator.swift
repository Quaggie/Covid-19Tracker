//
//  SearchCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    private let parent: ViewControllerPresenter
    private let cameFromHome: Bool
    private lazy var rootViewController = SearchUIComposer(cameFromHome: cameFromHome).compose()

    init(parent: ViewControllerPresenter, cameFromHome: Bool) {
        self.parent = parent
        self.cameFromHome = cameFromHome
        print("[SearchCoordinator] initialized!")
    }

    func start() {
        parent.show(rootViewController, sender: self)
    }

    deinit {
        print("[SearchCoordinator] deinitialized!")
    }
}
