//
//  NetworkManagerProtocol.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import Foundation

protocol NetworkManagerProtocol {
    func fetch(urlString: String,
               method: HTTPMethod,
               parameters: [String: Any],
               headers: [String: String],
               completion: @escaping (Result<Data, WebserviceError>) -> Void)
}
