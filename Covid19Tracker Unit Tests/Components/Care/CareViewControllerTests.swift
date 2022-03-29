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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class CareViewControllerTests: XCTestCase {
    func test_preferredStatusBarStyle_isCorrectType() {
        let sut = CareViewController()

        XCTAssertEqual(sut.preferredStatusBarStyle, .lightContent)
    }
}
