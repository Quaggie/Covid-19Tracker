//
//  DefaultDataRequest.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

protocol DataRequest {
    init(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String],
        cache: Bool,
        sessionConfiguration: URLSessionConfiguration,
        reachability: ReachabilityProtocol
    )
    func responseData(completion: @escaping (Result<Data, WebserviceError>) -> Void)
}

final class DefaultDataRequest: DataRequest {
    // MARK: - Properties
    private let url: URL
    private let method: HTTPMethod
    private let parameters: [String: Any]
    private let headers: [String: String]
    private let session: URLSession
    private let cache: Bool
    private let reachability: ReachabilityProtocol

    var task: URLSessionTask?

    // MARK: - Init
    init(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String],
        cache: Bool = false,
        sessionConfiguration: URLSessionConfiguration,
        reachability: ReachabilityProtocol = Reachability()
    ) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.cache = cache
        self.session = URLSession(configuration: sessionConfiguration)
        self.reachability = reachability
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

        if reachability.isConnectedToNetwork() {
            if cache {
                urlRequest.setValue(nil, forHTTPHeaderField: "Pragma")
                urlRequest.setValue(nil, forHTTPHeaderField: "Cache-Control")

                let twoHours = 7200
                urlRequest.setValue("max-age=\(twoHours)", forHTTPHeaderField: "Cache-Control")
            }
        }

        task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else {
                return completion(.failure(.unexpected))
            }
            if error != nil {
                return completion(.failure(WebserviceError.internalServerError))
            }

            guard (200 ..< 300) ~= response.statusCode, error == nil else {
                return completion(.failure(WebserviceError.unexpected))
            }

            completion(.success(data))
        }
        task?.resume()
    }
}
