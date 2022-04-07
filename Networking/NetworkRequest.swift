//
//  NetworkRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import Foundation

public protocol NetworkRequest {
    var task: URLSessionTask? { get }

    func cancel()
}

extension NetworkRequest {
    public var isCancelled: Bool {
        task?.state == .canceling
    }
}
