//
//  Tracker.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Firebase

protocol TrackerProtocol {
    var source: UIViewController { get }
    func screenView(name: String)
}

struct Tracker: TrackerProtocol {
    let source: UIViewController

    func screenView(name: String) {
        Analytics.setScreenName(name, screenClass: String(describing: source))
    }
}
