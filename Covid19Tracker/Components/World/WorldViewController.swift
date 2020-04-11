//
//  WorldViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class WorldViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    enum DatasourceType {
        case world(Timeline)
        case countries([Country])
    }

    // MARK: - Properties
    private var datasource: [DatasourceType] = [.world(Timeline(cases: 1699628, deaths: 102734, recovered: 376325))]
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16

    // MARK: - Views
    private let titleLabel = UILabel(text: "Covid-19 in the world", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var pageSelectorView = PageSelectorView(titles: ["Overview", "Countries"], selectedTitle: "Overview", delegate: self)
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear

        let bv = UIView()
        bv.backgroundColor = .clear
        cv.backgroundView = bv

        return cv
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(WorldDataCell.self)
    }

    private func setupGradient() {
        gradientLayer.colors = [Color.purpleDark.cgColor, Color.blueLight.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension WorldViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = datasource[section]

        switch item {
        case .world:
            return 1
        case .countries(let countries):
            return countries.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datasource[indexPath.section]

        switch item {
        case .world(let timeline):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorldDataCell
            cell.setup(timeline: timeline)
            return cell
        case .countries(let countries):
            return UICollectionViewCell()
        }
    }
}

extension WorldViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension WorldViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
        let height: CGFloat = 319
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
}

extension WorldViewController: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        collectionView.reloadData()
    }
}

extension WorldViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(pageSelectorView)
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        pageSelectorView.anchor(top: titleLabel.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                insets: .init(top: 27, left: sectionInset.right, bottom: 0, right: sectionInset.right))

        collectionView.anchor(top: pageSelectorView.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {
        setupGradient()
        pageSelectorView.setup()
    }
}
