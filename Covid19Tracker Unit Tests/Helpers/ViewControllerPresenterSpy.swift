//
//  ViewControllerPresenterSpy.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 18/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
@testable import Covid19_Tracker

final class ViewControllerPresenterSpy: ViewControllerPresenter {
    var viewControllers: [UIViewController] = []

    func show(_ vc: UIViewController, sender: Any?) {
        viewControllers.append(vc)
    }
}
