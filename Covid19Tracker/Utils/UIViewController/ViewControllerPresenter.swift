//
//  ViewControllerPresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

protocol ViewControllerPresenter: AnyObject {
    func show(_ vc: UIViewController, sender: Any?)
}
