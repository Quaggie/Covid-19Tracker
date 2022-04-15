//
//  WorldViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

final class WorldViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    enum OverviewDatasourceType {
        case totalCases(Timeline)
        case spreadOverTime([HistoricalTimelineDayInfo])
        case todayCases(Timeline)
    }

    // MARK: - Services
    private let tracker: TrackerProtocol
    private let worldService: WorldFetcher
    private let countryService: CountryFetcher
    private let historicalInfoService: HistoricalInfoFetcher
    private let worldOverviewUseCase: WorldOverviewFetcher

    // MARK: - Properties
    private var state: State = .loading {
        didSet {
            pageSelectorView.isUserInteractionEnabled = state == .success
            changeUIFor(state: state)
        }
    }
    private var selectedIndex: Int = 0
    private var overviewDatasource: [OverviewDatasourceType] = []
    private var countriesDatasource: [Country] = []
    private let sectionInset: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    private let lineSpacing: CGFloat = 16

    // MARK: - Views
    private let titleLabel = UILabel(text: "Covid-19 in the world", font: Font.regular(size: 24), textColor: Color.white)
    private lazy var pageSelectorView = PageSelectorView(titles: ["Overview", "Countries"], selectedTitle: "Overview")
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
        tracker: TrackerProtocol = Tracker(source: String(describing: WorldViewController.self)),
        worldService: WorldFetcher = WorldService(),
        countryService: CountryFetcher = CountryService(),
        historicalInfoService: HistoricalInfoFetcher = HistoricalInfoService()
    ) {
        self.tracker = tracker
        self.worldService = worldService
        self.countryService = countryService
        self.historicalInfoService = historicalInfoService
        self.worldOverviewUseCase = WorldOverviewService(worldService: worldService, historicalInfoService: historicalInfoService)
        super.init(nibName: nil, bundle: nil)

        pageSelectorView.delegate = self
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracker.screenView(name: "Overview")
    }

    private func registerCells() {
        collectionView.register(TotalCasesCell.self)
        collectionView.register(TodayCasesCell.self)
        collectionView.register(SpreadOverTimeCell.self)
        collectionView.register(SimpleCountryCasesCell.self)
    }

    private func fetchData() {
        self.state = .loading

        let dispatchGroup = DispatchGroup()
        var hasError = false

        dispatchGroup.enter()
        worldOverviewUseCase.fetch { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }

            switch result {
            case .success(let model):
                let timeline = Timeline.from(model: model.timeline)
                let timelineDayInfo = model.historicalTimelineWeekInfo.map {
                    HistoricalTimelineDayInfo(day: $0.day, active: $0.active, recovered: $0.recovered, deaths: $0.deaths)
                }
                self.overviewDatasource = [
                    .totalCases(timeline),
                    .spreadOverTime(timelineDayInfo),
                    .todayCases(timeline)
                ]
            case .failure:
                hasError = true
            }
        }

        dispatchGroup.enter()
        countryService.fetchAll(sort: true) { [weak self] (result) in
            guard let self = self else { return }
            dispatchGroup.leave()

            switch result {
            case .success(let countriesModel):
                let countries = countriesModel.map(Country.from(model:))
                self.countriesDatasource = countries
            case .failure:
                hasError = true
            }
        }


        dispatchGroup.notify(queue: .main) {
            self.state = hasError ? .error : .success
        }
    }

    private func changeUIFor(state: State) {
        switch state {
        case .loading:
            show(views: loadingView)
        case .success:
            show(views: pageSelectorView, collectionView)
            collectionView.reloadData()
        case .error:
            show(views: errorView)
        }
    }

    private func show(views: UIView...) {
        let allViews = [pageSelectorView, collectionView, loadingView, errorView]
        allViews.forEach { $0.isHidden = true }
        views.forEach { $0.isHidden = false }
    }

    private func goToCountryDetail(country: Country) {
        let controller = CountryUIComposer(countryName: country.country).compose()
        present(controller, animated: true)
    }
}

extension WorldViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == 1 {
            let country = countriesDatasource[indexPath.item]
            goToCountryDetail(country: country)
        }
    }
}

extension WorldViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return overviewDatasource.count
        } else {
            return countriesDatasource.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedIndex == 0 {
            let item = overviewDatasource[indexPath.item]

            switch item {
            case .totalCases(let timeline):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TotalCasesCell
                cell.setup(timeline: timeline)
                return cell
            case .spreadOverTime(let historicalTimelineList):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SpreadOverTimeCell
                cell.setup(historicalTimelineList: historicalTimelineList)
                return cell
            case .todayCases(let timeline):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TodayCasesCell
                cell.setup(timeline: timeline)
                return cell
            }
        } else {
            let item = countriesDatasource[indexPath.item]

            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SimpleCountryCasesCell
            cell.setup(country: item, index: indexPath.item)
            return cell
        }
    }
}

extension WorldViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndex == 0 {
            let item = overviewDatasource[indexPath.item]

            switch item {
            case .totalCases:
                let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
                return .init(width: width, height: TotalCasesCell.height)
            case .spreadOverTime:
                let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
                return .init(width: width, height: SpreadOverTimeCell.height)
            case .todayCases:
                let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
                return .init(width: width, height: TodayCasesCell.height)
            }
        } else {
            let width: CGFloat = view.frame.width - sectionInset.left - sectionInset.right
            return .init(width: width, height: SimpleCountryCasesCell.height)
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

extension WorldViewController: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        if selectedIndex == index {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        } else {
            if index == 0 {
                tracker.screenView(name: "Overview")
            } else {
                tracker.screenView(name: "Countries")
            }
            selectedIndex = index
            collectionView.reloadData()
        }
    }
}

extension WorldViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension WorldViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.addSubview(errorView)

        view.addSubview(titleLabel)
        view.addSubview(pageSelectorView)
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

        loadingView.anchor(top: pageSelectorView.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor)
        errorView.anchor(top: pageSelectorView.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
    }

    func setupAdditionalConfiguration() {
        pageSelectorView.setup()
    }
}
