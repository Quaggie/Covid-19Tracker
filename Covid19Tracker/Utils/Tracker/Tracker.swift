//
//  Tracker.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Firebase

protocol TrackerProtocol: AnyObject {
    func screenView(name: String)
}

final class Tracker: TrackerProtocol {
    private let source: String

    init(source: String) {
        self.source = source
    }

    func screenView(name: String) {
        Analytics.setScreenName(name, screenClass: source)
    }
}
