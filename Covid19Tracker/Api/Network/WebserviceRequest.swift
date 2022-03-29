//
//  WebserviceRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import Foundation

protocol WebserviceRequest {
    var task: URLSessionTask? { get }

    func cancel()
}

extension WebserviceRequest {
    var isCancelled: Bool {
        task?.state == .canceling
    }
}
