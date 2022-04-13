//
//  ConnectionError.swift
//  Data
//
//  Created by Jonathan Bijos on 07/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public enum ConnectionError: Error {
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

    static func from(networkError: NetworkError) -> Self {
        switch networkError {
        case .internalServerError:
            return .internalServerError
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .timedOut:
            return .timedOut
        case .unexpected:
            return .unexpected
        case .badRequest:
            return .badRequest
        case .unauthorized:
            return .unauthorized
        case .malformedURL:
            return .malformedURL
        case .unparseable:
            return .unparseable
        case .forbidden:
            return .forbidden
        case .preconditionFailed:
            return .preconditionFailed
        case .notFound:
            return .notFound
        case .conflict:
            return .conflict
        case .invalidResponse:
            return .invalidResponse
        }
    }
}
