//
//  WebserviceError.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

enum WebserviceError: Error {
    case internalServerError
    case notConnectedToInternet
    case timedOut
    case unexpected
    case badRequest
    case unauthorized
    case malformedURL
    case unparseable
    case forbidden
    case preconditionFailed
    case notFound
    case conflict
    case invalidResponse

    static func from(urlError: URLError) -> WebserviceError {
        switch urlError.code {
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .timedOut:
            return .timedOut
        default:
            return .unexpected
        }
    }

    static func from(statusCode: Int) -> WebserviceError {
        guard let error = HTTPStatusCode(rawValue: statusCode) else {
            return .unexpected
        }

        switch error {
        case .badRequest:
            return .badRequest
        case .unauthorized:
            return .unauthorized
        case .internalServerError:
            return .internalServerError
        case .forbidden:
            return .forbidden
        case .preconditionFailed:
            return .preconditionFailed
        case .notFound:
            return .notFound
        case .conflict:
            return .conflict
        }
    }
}
