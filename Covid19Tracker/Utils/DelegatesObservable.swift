//
//  DelegatesObservable.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

protocol DelegatesObservable {
    associatedtype T
    var observers: NSHashTable<AnyObject> { get set }
    var allobservers: [T] { get }
    func addListener(_ delegate: T)
}
