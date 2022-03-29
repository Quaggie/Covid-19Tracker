//
//  LoadingView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()

    // MARK: - Views
    private let activityIndicatorView: UIActivityIndicatorView = {
        let iv: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            iv = UIActivityIndicatorView(style: .large)
        } else {
            iv = UIActivityIndicatorView(style: .whiteLarge)
        }
        iv.color = Color.white
        iv.startAnimating()
        iv.hidesWhenStopped = true
        return iv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CodeView
extension LoadingView: CodeView {
    func buildViewHierarchy() {
        addSubview(activityIndicatorView)
    }

    func setupConstraints() {
        activityIndicatorView.anchorCenterSuperview()
    }

    func setupAdditionalConfiguration() {

    }
}

