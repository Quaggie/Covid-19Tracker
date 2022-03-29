//
//  CareViewControllerTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class CareViewController: UIViewController {
    let tracker: TrackerProtocol

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(tracker: TrackerProtocol) {
        self.tracker = tracker
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        tracker.screenView(name: String(describing: self))
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
}

extension CareViewControllerTests {
    func makeSUT() -> (CareViewController, TrackerSpy) {
        let tracker = TrackerSpy()
        let viewController = CareViewController(tracker: tracker)
        checkMemoryLeak(for: viewController)
        checkMemoryLeak(for: tracker)
        return (viewController, tracker)
    }
}

final class TrackerSpy: TrackerProtocol {
    var screenViews: [String] = []

    func screenView(name: String) {
        screenViews.append(name)
    }
}
