//
//  SearchViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    // MARK: - Views
    // TODO

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension SearchViewController: CodeView {
    func buildViewHierarchy() {

    }

    func setupConstraints() {

    }

    func setupAdditionalConfiguration() {

    }
}
