//
//  URLOpener.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

protocol URLOpener: AnyObject {
    func open(url: URL)
}

extension WeakRefVirtualProxy: URLOpener where T: URLOpener {
    func open(url: URL) {
        object?.open(url: url)
    }
}
