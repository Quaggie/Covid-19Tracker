//
//  DefaultDataRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

final class DefaultDataRequest: DataRequest {
    // MARK: - Properties
    private let url: URL
    private let method: HTTPMethod
    private let parameters: [String: Any]
    private let headers: [String: String]
    private let session: URLSession
    private let cache: Bool

    var task: URLSessionTask?

    // MARK: - Init
    init(url: URL, method: HTTPMethod, parameters: [String: Any], headers: [String: String], cache: Bool = false) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.cache = cache
        self.session = URLSession(configuration: .default)
    }

    // MARK: - Functions
    func cancel() {
        task?.cancel()
    }

    func responseData(completion: @escaping (Result<Data, WebserviceError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = method.rawValue

        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }

        if Reachability().isConnectedToNetwork() {
            if cache {
                urlRequest.setValue(nil, forHTTPHeaderField: "Pragma")
                urlRequest.setValue(nil, forHTTPHeaderField: "Cache-Control")

                let twoHours = 7200
                urlRequest.setValue("max-age=\(twoHours)", forHTTPHeaderField: "Cache-Control")
            }
        }

        task = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(WebserviceError.internalServerError))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(WebserviceError.unexpected))
                return
            }

            guard let data = data else {
                completion(.failure(WebserviceError.unparseable))
                return
            }

            completion(.success(data))
        }
        task?.resume()
    }
}
