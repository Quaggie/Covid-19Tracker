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
        let sut = BaseViewController()

        XCTAssertEqual(sut.view.layer.sublayers!.count, 1)
        XCTAssertTrue(sut.view.layer.sublayers![0] is CAGradientLayer)
    }
}
