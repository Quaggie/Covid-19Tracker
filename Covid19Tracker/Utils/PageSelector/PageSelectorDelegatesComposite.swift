//
//  PageSelectorDelegatesComposite.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

final class PageSelectorDelegatesComposite: DelegatesComposite {
    var delegates = NSHashTable<AnyObject>.weakObjects()

    func addDelegate(_ delegate: PageSelectorDelegate) {
        delegates.add(delegate)
    }

    private var allDelegates: [PageSelectorDelegate] {
        delegates.allObjects as! [PageSelectorDelegate]
    }
}

extension PageSelectorDelegatesComposite: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        allDelegates.forEach { $0.pageSelectorDidChange(index: index) }
    }
}
