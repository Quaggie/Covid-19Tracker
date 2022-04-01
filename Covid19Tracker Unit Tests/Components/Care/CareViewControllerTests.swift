//
//  CareViewControllerTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class CareViewControllerTests: XCTestCase {
    func test_preferredStatusBarStyle_isCorrectType() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }

    func test_viewDidAppear_tracksScreenView() {
        let (sut, tracker) = makeSUT()

        sut.viewDidAppear(false)

        XCTAssertEqual(tracker.screenViews[0], "Preventions")
    }

    func test_numberOfItemsInSection_returnsCorrectAmountOfItemsAndSections() {
        let dataSources: [DataSource] = [
            CareDataSource(preventionModels: [anyCareModel()], symptomModels: []),
            SourceDataSource()
        ]
        let dataSource = DataSourceComposite(dataSources: dataSources)
        checkMemoryLeak(for: dataSource)
        let (sut, _) = makeSUT(dataSource: dataSource)
        dataSource.registerCells(on: sut.collectionView)

        sut.loadViewIfNeeded()

        let totalSections = sut.collectionView.numberOfSections
        XCTAssertEqual(totalSections, dataSources.count)

        let section0Count = sut.collectionView.numberOfItems(inSection: 0)
        let expectedSection0Count = dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(section0Count, expectedSection0Count)

        let section1Count = sut.collectionView.numberOfItems(inSection: 1)
        let expectedSection1Count = dataSource.collectionView(sut.collectionView, numberOfItemsInSection: 1)
        XCTAssertEqual(section1Count, expectedSection1Count)
    }

    func test_cellForItem_returnsCorrectCell() {
        let dataSource = DataSourceComposite(
            dataSources: [
                CareDataSource(preventionModels: [anyCareModel(), anyCareModel()], symptomModels: []),
                SourceDataSource()
            ]
        )
        checkMemoryLeak(for: dataSource)
        let (sut, _) = makeSUT(dataSource: dataSource)
        dataSource.registerCells(on: sut.collectionView)

        sut.loadViewIfNeeded()

        let firstItemIndexPath = IndexPath(item: 0, section: 0)
        let expectedFirstCell = dataSource.collectionView(sut.collectionView, cellForItemAt: firstItemIndexPath)
        XCTAssert(expectedFirstCell is CareCardCell)

        let secondItemIndexPath = IndexPath(item: 1, section: 0)
        let expectedSecondCell = dataSource.collectionView(sut.collectionView, cellForItemAt: secondItemIndexPath)
        XCTAssert(expectedSecondCell is CareCardCell)

        let thirdItemIndexPath = IndexPath(item: 0, section: 1)
        let expectedThirdCell = dataSource.collectionView(sut.collectionView, cellForItemAt: thirdItemIndexPath)
        XCTAssert(expectedThirdCell is CareSourceCell)
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

    func test_pageSelectorDidChange_reloadsDataAndTracksScreenOnSelectorIndexChange() {
        let preventionModels: [CareModel] = [anyCareModel()]
        let symptomModels: [CareModel] = []
        let careDataSource = CareDataSource(preventionModels: preventionModels, symptomModels: symptomModels)
        let dataSource = DataSourceComposite(dataSources: [careDataSource])
        checkMemoryLeak(for: dataSource)
        let (sut, tracker) = makeSUT(dataSource: dataSource)

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), preventionModels.count)
        XCTAssertTrue(tracker.screenViews.isEmpty)

        careDataSource.pageSelectorDidChange(index: 1)
        sut.pageSelectorDidChange(index: 1)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), symptomModels.count)
        XCTAssertEqual(tracker.screenViews, ["Symptoms"])

        careDataSource.pageSelectorDidChange(index: 0)
        sut.pageSelectorDidChange(index: 0)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), preventionModels.count)
        XCTAssertEqual(tracker.screenViews, ["Symptoms", "Preventions"])
    }

    func test_pageSelectorDidChange_doesNotReloadDataAndDoesNotTrackScreenOnSelectorIndexRemainingTheSame() {
        let preventionModels: [CareModel] = [anyCareModel()]
        let careDataSource = CareDataSource(preventionModels: preventionModels, symptomModels: [])
        let dataSource = DataSourceComposite(dataSources: [careDataSource])
        checkMemoryLeak(for: dataSource)
        let (sut, tracker) = makeSUT(dataSource: dataSource)

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), preventionModels.count)
        XCTAssertTrue(tracker.screenViews.isEmpty)

        careDataSource.pageSelectorDidChange(index: 0)
        sut.pageSelectorDidChange(index: 0)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), preventionModels.count)
        XCTAssertTrue(tracker.screenViews.isEmpty)

        careDataSource.pageSelectorDidChange(index: 0)
        sut.pageSelectorDidChange(index: 0)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), preventionModels.count)
        XCTAssertTrue(tracker.screenViews.isEmpty)
    }
}

extension CareViewControllerTests {
    func anyCareModel() -> CareModel {
        CareModel(title: "Test", color: .white, description: "", image: UIImage())
    }
}

extension CareViewControllerTests {
    func makeSUT(dataSource: DataSource? = nil, delegateFlowLayout: UICollectionViewDelegateFlowLayout? = nil, file: StaticString = #filePath, line: UInt = #line) -> (CareViewController, TrackerSpy) {
        let tracker = TrackerSpy()
        let delegate = CareTrackerAdaptor(tracker: tracker)
        let viewController = CareViewController(delegate: delegate, dataSource: dataSource, delegateFlowLayout: delegateFlowLayout, pageSelectorViewDelegate: PageSelectorDelegatesComposite())
        checkMemoryLeak(for: viewController, file: file, line: line)
        checkMemoryLeak(for: delegate, file: file, line: line)
        checkMemoryLeak(for: tracker, file: file, line: line)
        return (viewController, tracker)
    }
}
