//
//  DelegatesComposite.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

protocol DelegatesComposite {
    associatedtype T
    var delegates: NSHashTable<AnyObject> { get set }
    func addDelegate(_ delegate: T)
}
