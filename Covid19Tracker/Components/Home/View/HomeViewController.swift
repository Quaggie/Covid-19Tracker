//
//  HomeViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 24/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

final class HomeViewController: BaseViewController {
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
    private let coordinator: HomeCoordinatorDelegate
    private let tracker: TrackerProtocol
    private var selectedCountry: Country? {
        didSet {
            selectedCountryButton.setTitle(selectedCountry?.country, for: .normal)
        }
    }
    private var state: State = .loading {
        didSet {
            selectedCountryButton.isEnabled = state != .loading
            changeUIFor(state: state)
        }
    }
    private var datasource: [DatasourceType] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16
    private let interItemSpacing: CGFloat = 16

    // MARK: - Views
    private let titleLabel = UILabel(text: "Covid-19 in my country", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var selectedCountryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = Color.white
        btn.semanticContentAttribute = .forceRightToLeft

        btn.setTitle("Brazil", for: .normal)
        btn.setTitleColor(Color.white, for: .normal)
        btn.titleLabel?.font = Font.bold(size: 32)

        btn.setImage(UIImage(named: "pencil_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageEdgeInsets = .init(top: 0, left: 19, bottom: 0, right: 0)

        btn.addTarget(self, action: #selector(didTapSelectCountryButton), for: .touchUpInside)

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Init
    init(
        coordinator: HomeCoordinatorDelegate,
        tracker: TrackerProtocol = Tracker(source: String(describing: HomeViewController.self)),
        countryService: CountryServiceProtocol,
        historicalInfoService: HistoricalInfoServiceProtocol
    ) {
        self.coordinator = coordinator
        self.tracker = tracker
        self.countryService = countryService
        self.historicalInfoService = historicalInfoService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
        fetchData()

        NotificationCenter.default.addObserver(forName: .onSearchCountry, object: nil, queue: .main) { (notification) in
            guard let country = notification.userInfo?["country"] as? Country else {
                return
            }
            self.tabBarController?.selectedIndex = 0
            self.selectedCountry = country
            self.fetchData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "Home")
    }

    private func registerCells() {
        collectionView.register(TotalCasesCell.self)
        collectionView.register(TodayCasesCell.self)
        collectionView.register(SpreadOverTimeCell.self)
        collectionView.register(PercentRateCell.self)
    }

    private func fetchData() {
        state = .loading

        countryService.fetch(country: selectedCountry?.country ?? "Brazil") { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let countryModel):
                self.historicalInfoService.fetch(country: countryModel.country) { [weak self] (result) in
                    guard let self = self else { return }

                    switch result {
                    case .success(let historicalCountryInfoModel):
                        let country = Country.from(model: countryModel)
                        let historicalCountryInfo = HistoricalCountryInfo.from(model: historicalCountryInfoModel)
                        self.selectedCountry = country
                        self.datasource = [
                            .totalCases(country),
                            .percentRate(type: .recovery, percent: Double(country.recovered) / Double(country.cases)),
                            .percentRate(type: .fatality, percent: Double(country.deaths) / Double(country.cases)),
                            .spreadOverTime(historicalCountryInfo.timeline),
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

    // MARK: - Actions
    @objc private func didTapSelectCountryButton() {
        coordinator.changeCountry()
    }
}

extension HomeViewController: UICollectionViewDataSource {
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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

extension HomeViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension HomeViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)

        view.addSubview(titleLabel)
        view.addSubview(selectedCountryButton)
    }

    func setupConstraints() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          insets: .init(top: 36, left: sectionInset.left, bottom: 0, right: sectionInset.right))

        selectedCountryButton.anchor(top: titleLabel.bottomAnchor,
                                     leading: view.leadingAnchor,
                                     insets: .init(top: 10, left: sectionInset.left, bottom: 0, right: sectionInset.right))
        selectedCountryButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive = true

        collectionView.anchor(top: selectedCountryButton.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)

        loadingView.anchor(top: selectedCountryButton.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor)
        errorView.anchor(top: selectedCountryButton.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {

    }
}
