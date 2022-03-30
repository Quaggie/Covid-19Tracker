//
//  WeakRefVirtualProxy.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ViewControllerPresenter where T: ViewControllerPresenter {
    func show(_ vc: UIViewController, sender: Any?) {
        object?.show(vc, sender: sender)
    }
}

extension WeakRefVirtualProxy: PageSelectorViewDelegate where T: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        object?.pageSelectorViewDidChange(index: index)
    }
}

extension WeakRefVirtualProxy: PageSelectorDelegate where T: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        object?.pageSelectorDidChange(index: index)
    }
}
