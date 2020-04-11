//
//  NewsViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class NewsViewController: BaseViewController {
    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView(), coneImageView, titleLabel, subtitleLabel, UIView()])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 24
        return sv
    }()
    private let coneImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "cone_icon"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Color.white
        return iv
    }()
    private let titleLabel = UILabel(text: "Available soon", font: Font.bold(size: 24), textColor: Color.white, textAlignment: .center)
    private let subtitleLabel = UILabel(text: "We are still building this feature. Soon it will be available",
                                        font: Font.regular(size: 18),
                                        textColor: Color.white,
                                        textAlignment: .center,
                                        numberOfLines: 0)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension NewsViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(stackView)
    }

    func setupConstraints() {
        stackView.anchor(leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         insets: .init(top: 0, left: 40, bottom: 0, right: 40))
        stackView.anchor(heightAnchor: view.heightAnchor, heightMultiplier: 0.5)
        stackView.anchorCenterYToSuperview()
        coneImageView.anchor(height: 117)
    }

    func setupAdditionalConfiguration() {

    }
}
