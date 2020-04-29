//
//  DataRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import Foundation

protocol DataRequest {
    init(url: URL, method: HTTPMethod, parameters: [String: Any], headers: [String: String], cache: Bool)
    func responseData(completion: @escaping (Result<Data, WebserviceError>) -> Void)
}
