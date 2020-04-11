//
//  BaseViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let gradientLayer = CAGradientLayer()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradientLayer.frame = view.bounds
    }
}
