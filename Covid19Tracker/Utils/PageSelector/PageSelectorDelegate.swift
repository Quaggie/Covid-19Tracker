//
//  PageSelectorDelegate.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

protocol PageSelectorDelegate: AnyObject {
    func pageSelectorDidChange(index: Int)
}

extension WeakRefVirtualProxy: PageSelectorDelegate where T: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        object?.pageSelectorDidChange(index: index)
    }
}
