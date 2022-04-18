//
//  UIComposer.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

protocol UIComposer {
    associatedtype T
    func compose() -> T
}
