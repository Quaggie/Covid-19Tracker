//
//  CountryTrackerAdapter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 24/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class CountryTrackerAdapter {
    private let tracker: TrackerProtocol

    init(tracker: TrackerProtocol = Tracker(source: String(describing: CountryViewController.self))) {
        self.tracker = tracker
    }
}

extension CountryTrackerAdapter: CountryViewControllerDelegate {
    func viewDidAppear() {
        tracker.screenView(name: "Country Details")
    }
}
