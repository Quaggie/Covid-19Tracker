//
//  CountryCoordinator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class CountryCoordinator: Coordinator {
    private let parent: ViewControllerPresenter
    private let countryName: String

    init(parent: ViewControllerPresenter, countryName: String) {
        self.parent = parent
        self.countryName = countryName
        print("[CountryCoordinator] initialized!")
    }

    func start() {
        let vc = CountryUIComposer(countryName: countryName).compose()
        parent.show(vc, sender: self)
    }

    deinit {
        print("[CountryCoordinator] deinitialized!")
    }
}
