//
//  BaseViewControllerTests.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 24/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import XCTest
@testable import Covid19_Tracker

class BaseViewControllerTests: XCTestCase {
    func test_viewDidLoad_shouldSetupGradient() {
        let sut = makeSut()

        XCTAssertEqual(sut.view.layer.sublayers!.count, 1)
        XCTAssertTrue(sut.view.layer.sublayers![0] is CAGradientLayer)
    }

    func test_viewDidLayoutSubviews_shouldUpdateGradientLayerFrame() {
        let sut = makeSut()

        XCTAssertEqual(sut.view.layer.sublayers![0].frame, .zero)

        let frame = CGRect(x: 2, y: 2, width: 10, height: 10)
        sut.view.bounds = frame
        sut.viewDidLayoutSubviews()

        XCTAssertEqual(sut.view.layer.sublayers![0].frame, frame)
    }
}

extension BaseViewControllerTests {
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> BaseViewController {
        let sut = BaseViewController()
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
