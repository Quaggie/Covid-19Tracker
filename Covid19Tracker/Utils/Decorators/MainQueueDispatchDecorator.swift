//
//  MainQueueDispatchDecorator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    var instance: T

    init(instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}
