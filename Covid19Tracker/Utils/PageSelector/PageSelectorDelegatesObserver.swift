//
//  PageSelectorDelegatesObserver.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

final class PageSelectorDelegatesObserver: DelegatesObservable {
    var observers = NSHashTable<AnyObject>.weakObjects()

    func addListener(_ delegate: PageSelectorDelegate) {
        observers.add(delegate)
    }

    private var allobservers: [PageSelectorDelegate] {
        observers.allObjects as! [PageSelectorDelegate]
    }
}

extension PageSelectorDelegatesObserver: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        allobservers.forEach { $0.pageSelectorDidChange(index: index) }
    }
}
