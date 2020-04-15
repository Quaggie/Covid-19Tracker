//
//  ErrorView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func errorViewDidTapTryAgain()
}

final class ErrorView: UIView {
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private unowned let delegate: ErrorViewDelegate

    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView(), imageView, titleLabel, SpaceView(space: 8), button, UIView()])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 24
        return sv
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "error_icon"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Color.white
        return iv
    }()
    private let titleLabel = UILabel(text: "Something went wrong",
                                     font: Font.bold(size: 24),
                                     textColor: Color.white,
                                     textAlignment: .center,
                                     numberOfLines: 0)
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = Color.white
        btn.setTitle("Try again", for: .normal)
        btn.setTitleColor(Color.white, for: .normal)
        btn.titleEdgeInsets = .init(top: 0, left: 34, bottom: 0, right: 34)
        btn.titleLabel?.font = Font.regular(size: 18)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Color.white.cgColor
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return btn
    }()

    // MARK: - Init
    init(delegate: ErrorViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Private functions
    private func setupGradient() {
        gradientLayer.colors = [Color.purpleDark.cgColor, Color.blueLight.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc private func didTapButton() {
        delegate.errorViewDidTapTryAgain()
    }
}

// MARK: - CodeView
extension ErrorView: CodeView {
    func buildViewHierarchy() {
        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.anchor(leading: leadingAnchor,
                         trailing: trailingAnchor,
                         insets: .init(top: 0, left: 40, bottom: 0, right: 40))
        stackView.anchor(heightAnchor: heightAnchor, heightMultiplier: 0.55)
        stackView.anchorCenterYToSuperview()

        imageView.anchor(height: 117)

        button.anchor(height: 40, width: 145)
    }

    func setupAdditionalConfiguration() {
        setupGradient()
    }
}
