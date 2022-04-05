//
//  CareTrackerAdapter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 05/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class CareTrackerAdapter {
    private let tracker: TrackerProtocol
    private var selectedIndex = 0

    init(tracker: TrackerProtocol = Tracker(source: String(describing: CareViewController.self))) {
        self.tracker = tracker
    }

    private func trackScreenFor(index: Int) {
        if index == 0 {
            tracker.screenView(name: "Preventions")
        } else {
            tracker.screenView(name: "Symptoms")
        }
    }
}

extension CareTrackerAdapter: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        guard selectedIndex != index else { return }
        selectedIndex = index
        trackScreenFor(index: index)
    }
}

extension CareTrackerAdapter: CareViewControllerDelegate {
    func viewDidAppear() {
        trackScreenFor(index: selectedIndex)
    }
}
