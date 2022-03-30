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

    var allobservers: [PageSelectorDelegate] {
        observers.allObjects as! [PageSelectorDelegate]
    }

    func addListener(_ delegate: PageSelectorDelegate) {
        observers.add(delegate)
    }
}

extension PageSelectorDelegatesObserver: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        allobservers.forEach { $0.pageSelectorDidChange(index: index) }
    }
}
