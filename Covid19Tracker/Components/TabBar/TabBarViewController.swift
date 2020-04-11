//
//  TabBarViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

//final class TabBarViewController: UIViewController {
//    private let bottomStackView: UIStackView = {
//        let sv = UIStackView()
//        sv.axis = .horizontal
//        sv.distribution = .fillEqually
//        sv.alignment = .center
//        sv.spacing = 0
//        return sv
//    }()
//
//    private let homeImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "tabbar_home"))
//        iv.contentMode = .scaleAspectFit
//        iv.tintColor = Color.blueDark
//        return iv
//    }()
//    private let homeLabel = UILabel(text: "Home", font: Font.semiBold(size: 10), textColor: Color.blueDark, textAlignment: .center)
//
//    private let worldImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "tabbar_world"))
//        iv.contentMode = .scaleAspectFit
//        iv.tintColor = Color.blueDark
//        return iv
//    }()
//    private let worldLabel = UILabel(text: "World", font: Font.semiBold(size: 10), textColor: Color.blueDark, textAlignment: .center)
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        setupViews()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func createIconStackView(imageView: UIImageView, label: UILabel) -> UIStackView {
//        let sv = UIStackView(arrangedSubviews: [imageView, label])
//        sv.backgroundColor = Color.white
//        sv.axis = .vertical
//        sv.distribution = .fill
//        sv.alignment = .center
//        sv.spacing = 5
//        return sv
//    }
//}
//
//extension TabBarViewController: CodeView {
//    func buildViewHierarchy() {
//        view.addSubview(bottomStackView)
//
//        bottomStackView.addArrangedSubview(createIconStackView(imageView: homeImageView, label: homeLabel))
//        bottomStackView.addArrangedSubview(createIconStackView(imageView: worldImageView, label: worldLabel))
//    }
//
//    func setupConstraints() {
//        bottomStackView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        bottomStackView.anchor(height: 56 + additionalSafeAreaInsets.bottom)
//    }
//
//    func setupAdditionalConfiguration() {
//
//    }
//}

final class TabBarViewController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupViews()

        let countryViewController = UIViewController()
        let countryNavigationController = UINavigationController(rootViewController: countryViewController)
        countryNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let worldViewController = WorldViewController()
        let worldNavigationController = UINavigationController(rootViewController: worldViewController)
        worldViewController.navigationController?.isNavigationBarHidden = true
        worldNavigationController.tabBarItem = UITabBarItem(title: "World", image: UIImage(systemName: "world.fill"), tag: 1)

        viewControllers = [countryNavigationController, worldNavigationController]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarViewController: CodeView {
    func buildViewHierarchy() {

    }

    func setupConstraints() {

    }

    func setupAdditionalConfiguration() {

    }
}
