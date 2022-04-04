//
//  CountryViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Data

final class CountryViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    enum DatasourceType {
        case totalCases(Country)
        case percentRate(type: PercentRateCell.Status, percent: Double)
        case spreadOverTime([HistoricalTimelineDayInfo])
        case todayCases(Country)
    }

    // MARK: - Services
    private let countryService: CountryServiceProtocol
    private let historicalInfoService: HistoricalInfoServiceProtocol

    // MARK: - Properties
    private let tracker: TrackerProtocol
    private let countryName: String
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }
    private var datasource: [DatasourceType] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16
    private let interItemSpacing: CGFloat = 16

    // MARK: - Views
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "back_icon"), for: .normal)
        btn.tintColor = Color.white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        return btn
    }()
    private let titleLabel = UILabel(text: "", font: Font.regular(size: 24), textColor: Color.white)
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

    // MARK: - Init
    init(
        tracker: TrackerProtocol = Tracker(source: String(describing: CountryViewController.self)),
        countryName: String,
        countryService: CountryServiceProtocol,
        historicalInfoService: HistoricalInfoServiceProtocol
    ) {
        self.tracker = tracker
        self.countryName = countryName
        self.countryService = countryService
        self.historicalInfoService = historicalInfoService
        super.init(nibName: nil, bundle: nil)

        self.titleLabel.text = countryName
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "Country Details")
    }

    // MARK: - Private functions
    private func registerCells() {
        collectionView.register(TotalCasesCell.self)
        collectionView.register(TodayCasesCell.self)
        collectionView.register(SpreadOverTimeCell.self)
        collectionView.register(PercentRateCell.self)
    }

    private func fetchData() {
        state = .loading

        countryService.fetch(country: countryName) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let countryModel):
                self.historicalInfoService.fetch(country: countryModel.country) { [weak self] (result) in
                    guard let self = self else { return }

                    switch result {
                    case .success(let historicalInfo):
                        let country = Country.from(model: countryModel)
                        self.datasource = [
                            .totalCases(country),
                            .percentRate(type: .recovery, percent: Double(country.recovered) / Double(country.cases)),
                            .percentRate(type: .fatality, percent: Double(country.deaths) / Double(country.cases)),
                            .spreadOverTime(historicalInfo.timeline),
                            .todayCases(country)
                        ]
                        self.state = .success
                    case .failure:
                        self.state = .error
                    }
                }
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

    @objc private func closeModal() {
        dismiss(animated: true)
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
        case .percentRate(let type, let percent):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PercentRateCell
            cell.setup(type: type, percent: percent)
            return cell
        case .spreadOverTime(let historicalTimelineList):
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpreadOverTimeCell
            cell.setup(historicalTimelineList: historicalTimelineList)
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
        case .percentRate:
            let sectionWidth: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
            let width = (sectionWidth / 2) - (interItemSpacing / 2)
            return .init(width: width, height: PercentRateCell.height)
        case .spreadOverTime:
            let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
            return .init(width: width, height: SpreadOverTimeCell.height)
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
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
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
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
    }

    func setupConstraints() {
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          insets: .init(top: 24, left: sectionInset.left, bottom: 0, right: 0))
        backButton.anchor(height: 40, width: 40)

        titleLabel.anchor(top: backButton.topAnchor,
                          leading: backButton.trailingAnchor,
                          bottom: backButton.bottomAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 0, left: 20, bottom: 0, right: sectionInset.right))

        collectionView.anchor(top: titleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)

        loadingView.anchor(top: titleLabel.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor)
        errorView.anchor(top: titleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {
        
    }
}
