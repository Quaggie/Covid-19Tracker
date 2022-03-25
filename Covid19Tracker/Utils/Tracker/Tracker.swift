//
//  Tracker.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Firebase

protocol TrackerProtocol {
    var source: String { get }
    func screenView(name: String)
}

struct Tracker: TrackerProtocol {
    let source: String

    func screenView(name: String) {
        Analytics.setScreenName(name, screenClass: source)
    }
}
