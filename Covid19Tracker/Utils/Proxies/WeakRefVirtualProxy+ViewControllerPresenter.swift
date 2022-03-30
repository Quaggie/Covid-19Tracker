//
//  WeakRefVirtualProxy+ViewControllerPresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

extension WeakRefVirtualProxy: ViewControllerPresenter where T: ViewControllerPresenter {
    func show(_ vc: UIViewController, sender: Any?) {
        object?.show(vc, sender: sender)
    }
}
