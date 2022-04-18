//
//  WorldCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class WorldCoordinator: Coordinator {
    private let parent: ViewControllerPresenter

    init(parent: ViewControllerPresenter) {
        self.parent = parent
        print("[WorldCoordinator] initialized!")
    }

    func start() {
        let vc = WorldUIComposer().compose()
        parent.show(vc, sender: self)
    }

    deinit {
        print("[WorldCoordinator] deinitialized!")
    }
}
