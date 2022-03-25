//
//  BaseViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private(set) lazy var tracker: TrackerProtocol = Tracker(source: String(describing: self))
    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradientLayer.frame = view.bounds
    }

    private func setupGradient() {
        gradientLayer.colors = [Color.purpleDark.cgColor, Color.blueLight.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
