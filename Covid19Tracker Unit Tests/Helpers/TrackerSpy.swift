//
//  TrackerSpy.swift
//  Covid19Tracker_unit_tests
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

@testable import Covid19_Tracker

final class TrackerSpy: TrackerProtocol {
    var screenViews: [String] = []

    func screenView(name: String) {
        screenViews.append(name)
    }
}
