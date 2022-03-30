//
//  CareViewControllerTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class CareViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    private weak var tracker: TrackerProtocol?
    private weak var dataSource: UICollectionViewDataSource?
    private weak var delegate: UICollectionViewDelegateFlowLayout?

    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = dataSource
        cv.delegate = delegate

        return cv
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(tracker: TrackerProtocol, dataSource: UICollectionViewDataSource?, delegate: UICollectionViewDelegateFlowLayout?) {
        self.tracker = tracker
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        collectionView.fillSuperview()
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        tracker?.screenView(name: String(describing: self))
    }
}

protocol CellRegistrationable: AnyObject {
    func registerCells(on collectionView: UICollectionView)
}

final class DataSourceComposite: NSObject, UICollectionViewDataSource, CellRegistrationable {
    typealias DataSource = UICollectionViewDataSource & CellRegistrationable
    private let dataSources: [DataSource]

    init(dataSources: [DataSource]) {
        self.dataSources = dataSources
    }

    func registerCells(on collectionView: UICollectionView) {
        for dataSource in dataSources {
            dataSource.registerCells(on: collectionView)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSources.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSources.reduce(0) { partialResult, dataSource in
            partialResult + dataSource.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dataSource(forSection: indexPath.section, in: collectionView).collectionView(collectionView, cellForItemAt: indexPath)
    }

    private func dataSource(forSection section: Int, in collectionView: UICollectionView) -> UICollectionViewDataSource {
        var sectionCount = 0
        for dataSource in dataSources {
            sectionCount += dataSource.numberOfSections?(in: collectionView) ?? 1
            if section < sectionCount {
                return dataSource
            }
        }
        fatalError("No dataSource found for section \(section)")
    }
}

final class CareDataSource: NSObject, UICollectionViewDataSource, CellRegistrationable {
    var models: [CareModel] = []

    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CareCardCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareCardCell
        cell.setup(model: model)
        return cell
    }
}

final class SourceDataSource: NSObject, UICollectionViewDataSource, CellRegistrationable {
    private let source = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019")!

    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CareSourceCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareSourceCell
        cell.onTapLink = {
            let url = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019")!
            UIApplication.shared.open(url)
        }
        return cell
    }
}

final class DelegateFlowLayoutComposite: NSObject, UICollectionViewDelegateFlowLayout {
    let delegateFlowLayouts: [UICollectionViewDelegateFlowLayout]

    init(delegateFlowLayouts: [UICollectionViewDelegateFlowLayout]) {
        self.delegateFlowLayouts = delegateFlowLayouts
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        delegateFlowLayout(forSection: indexPath.section)
            .collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        delegateFlowLayout(forSection: section)
            .collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        delegateFlowLayout(forSection: section)
            .collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
    }

    private func delegateFlowLayout(forSection section: Int) -> UICollectionViewDelegateFlowLayout {
        delegateFlowLayouts[section]
    }
}

final class CareDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        return CGSize(width: width, height: CareCardCell.height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}

final class SourceDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        return CGSize(width: width, height: CareSourceCell.height)
    }
}

class CareViewControllerTests: XCTestCase {
    func test_preferredStatusBarStyle_isCorrectType() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }

    func test_viewDidAppear_tracksScreenView() {
        let (sut, tracker) = makeSUT()

        sut.viewDidAppear(false)

        XCTAssertEqual(tracker.screenViews[0], String(describing: sut))
    }

    func test_numberOfItemsInSection_returnsCorrectAmountOfItems() {
        let models: [CareModel] = [anyCareModel()]
        let careDataSource = CareDataSource()
        let dataSource = DataSourceComposite(
            dataSources: [
                careDataSource,
                SourceDataSource()
            ]
        )
        checkMemoryLeak(for: careDataSource)
        checkMemoryLeak(for: dataSource)
        careDataSource.models = models
        let (sut, _) = makeSUT(dataSource: dataSource)
        dataSource.registerCells(on: sut.collectionView)

        sut.loadViewIfNeeded()

        let count = sut.collectionView.numberOfItems(inSection: 0)
        let expectedCount = dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, expectedCount)
    }

    func test_cellForItem_returnsCorrectCell() {
        let models: [CareModel] = [anyCareModel()]
        let careDataSource = CareDataSource()
        let dataSource = DataSourceComposite(
            dataSources: [
                careDataSource,
                SourceDataSource()
            ]
        )
        checkMemoryLeak(for: careDataSource)
        checkMemoryLeak(for: dataSource)
        careDataSource.models = models
        let (sut, _) = makeSUT(dataSource: dataSource)
        dataSource.registerCells(on: sut.collectionView)

        sut.loadViewIfNeeded()

        let firstItemIndexPath = IndexPath(item: 0, section: 0)
        let expectedFirstCell = dataSource.collectionView(sut.collectionView, cellForItemAt: firstItemIndexPath)
        XCTAssert(expectedFirstCell is CareCardCell)

        let secondItemIndexPath = IndexPath(item: 0, section: 1)
        let expectedSecondCell = dataSource.collectionView(sut.collectionView, cellForItemAt: secondItemIndexPath)
        XCTAssert(expectedSecondCell is CareSourceCell)
    }

    func test_sizeForItem_returnCorrectSize() {
        let delegateFlowLayout = DelegateFlowLayoutComposite(
            delegateFlowLayouts: [
                CareDelegateFlowLayout(),
                SourceDelegateFlowLayout()
            ]
        )
        checkMemoryLeak(for: delegateFlowLayout)
        let (sut, _) = makeSUT(delegateFlowLayout: delegateFlowLayout)

        sut.loadViewIfNeeded()

        let cellWidth: CGFloat = sut.collectionView.frame.width - sut.collectionView.contentInset.left - sut.collectionView.contentInset.right

        let firstItemIndexPath = IndexPath(item: 0, section: 0)
        let firstItemSize = delegateFlowLayout.collectionView(sut.collectionView, layout: sut.collectionView.collectionViewLayout, sizeForItemAt: firstItemIndexPath)
        let expectedFirstItemSize = CGSize(width: cellWidth, height: CareCardCell.height)
        XCTAssertEqual(firstItemSize, expectedFirstItemSize)

        let secondItemIndexPath = IndexPath(item: 0, section: 1)
        let secondItemSize = delegateFlowLayout.collectionView(sut.collectionView, layout: sut.collectionView.collectionViewLayout, sizeForItemAt: secondItemIndexPath)
        let expectedsecondItemSize = CGSize(width: cellWidth, height: CareSourceCell.height)
        XCTAssertEqual(secondItemSize, expectedsecondItemSize)
    }

    func test_minimumLineSpacing_returnsCorrectLineSpacing() {
        let delegateFlowLayout = DelegateFlowLayoutComposite(
            delegateFlowLayouts: [
                CareDelegateFlowLayout(),
                SourceDelegateFlowLayout()
            ]
        )
        checkMemoryLeak(for: delegateFlowLayout)
        let (sut, _) = makeSUT(delegateFlowLayout: delegateFlowLayout)

        sut.loadViewIfNeeded()

        let firstSectionLineSpacing = delegateFlowLayout.collectionView(sut.collectionView, layout: sut.collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
        let expectedFirstSectionLineSpacing: CGFloat = 16
        XCTAssertEqual(firstSectionLineSpacing, expectedFirstSectionLineSpacing)

        let secondSectionLineSpacing = delegateFlowLayout.collectionView(sut.collectionView, layout: sut.collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 1)
        let expectedSecondSectionLineSpacing: CGFloat = .zero
        XCTAssertEqual(secondSectionLineSpacing, expectedSecondSectionLineSpacing)
    }
}

extension CareViewControllerTests {
    func anyCareModel() -> CareModel {
        CareModel(title: "Test", color: .white, description: "", image: UIImage())
    }
}

extension CareViewControllerTests {
    func makeSUT(dataSource: UICollectionViewDataSource? = nil, delegateFlowLayout: UICollectionViewDelegateFlowLayout? = nil, file: StaticString = #filePath, line: UInt = #line) -> (CareViewController, TrackerSpy) {
        let tracker = TrackerSpy()
        let viewController = CareViewController(tracker: tracker, dataSource: dataSource, delegate: delegateFlowLayout)
        checkMemoryLeak(for: viewController, file: file, line: line)
        checkMemoryLeak(for: tracker, file: file, line: line)
        return (viewController, tracker)
    }
}
