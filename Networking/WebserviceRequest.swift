//
//  WebserviceRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import Foundation

public protocol WebserviceRequest {
    var task: URLSessionTask? { get }

    func cancel()
}

extension WebserviceRequest {
    public var isCancelled: Bool {
        task?.state == .canceling
    }
}
