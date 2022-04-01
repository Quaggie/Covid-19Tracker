//
//  HTTPStatusCode.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 28/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

public enum HTTPStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case preconditionFailed = 412
    case conflict = 409
}
