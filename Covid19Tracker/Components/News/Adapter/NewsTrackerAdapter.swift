//
//  NewsTrackerAdapter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

final class NewsTrackerAdapter {
    private let tracker: TrackerProtocol

    init(tracker: TrackerProtocol = Tracker(source: String(describing: NewsViewController.self))) {
        self.tracker = tracker
    }
}

extension NewsTrackerAdapter: NewsViewControllerDelegate {
    func viewDidAppear() {
        tracker.screenView(name: "News")
    }
}
