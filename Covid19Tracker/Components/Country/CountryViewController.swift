//
//  CountryViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class CountryViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    enum DatasourceType {
        case totalCases(Country)
        case todayCases(Country)
    }

    // MARK: - Services
    private let service = CountryService()

    // MARK: - Properties
    private var selectedCountry: Country?
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }
    private var datasource: [DatasourceType] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16

    // MARK: - Views
    private let titleLabel = UILabel(text: "Covid-19 in my country", font: Font.regular(size: 24), textColor: Color.white)
    private let selectedCountryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = Color.white
        btn.semanticContentAttribute = .forceRightToLeft
        btn.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)

        btn.setTitle("Brazil", for: .normal)
        btn.setTitleColor(Color.white, for: .normal)
        btn.titleLabel?.font = Font.bold(size: 32)

        btn.setImage(UIImage(named: "pencil_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageEdgeInsets = .init(top: 0, left: 19, bottom: 0, right: 0)

        return btn
    }()
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
    private let loadingView = LoadingView()
    private lazy var errorView = ErrorView(delegate: self)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()
    }

    private func registerCells() {
        collectionView.register(TotalCasesCell.self)
        collectionView.register(TodayCasesCell.self)
    }

    private func fetchData() {
        self.state = .loading

        service.fetch(country: selectedCountry?.country ?? "Brazil") { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let country):
                self.selectedCountry = country
                self.datasource = [.totalCases(country), .todayCases(country)]
                self.state = .success
            case .failure:
                self.state = .error
            }
        }
    }

    private func changeUIFor(state: State) {
        switch state {
        case .loading:
            show(view: loadingView)
        case .success:
            show(view: collectionView)
            selectedCountryButton.setTitle(selectedCountry?.country, for: .normal)
            collectionView.reloadData()
        case .error:
            show(view: errorView)
        }
    }

    private func show(view: UIView) {
        [collectionView, loadingView, errorView].forEach { (v) in
            if view == v {
                v.isHidden = false
            } else {
                v.isHidden = true
            }
        }
    }
}

extension CountryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datasource[indexPath.item]

        switch item {
        case .totalCases(let country):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TotalCasesCell
            cell.setup(timeline: country.timeline)
            return cell
        case .todayCases(let country):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TodayCasesCell
            cell.setup(timeline: country.timeline)
            return cell
        }
    }
}

extension CountryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = datasource[indexPath.item]

        switch item {
        case .totalCases:
            let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
            return .init(width: width, height: TotalCasesCell.height)
        case .todayCases:
            let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
            return .init(width: width, height: TodayCasesCell.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
}

extension CountryViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension CountryViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(selectedCountryButton)

        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        selectedCountryButton.anchor(top: titleLabel.bottomAnchor,
                                     leading: view.leadingAnchor,
                                     insets: .init(top: 10, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        collectionView.anchor(top: selectedCountryButton.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)

        loadingView.fillSuperview()
        errorView.fillSuperview()
    }

    func setupAdditionalConfiguration() {
        
    }
}
