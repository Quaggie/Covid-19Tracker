//
//  WebserviceError.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

enum WebserviceError: Error {
    case internalServerError
    case notConnectedToInternet
    case timedOut
    case unexpected
    case unauthorized
    case malformedURL
    case unparseable
    case forbidden
    case preconditionFailed
}
