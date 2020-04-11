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

    var task: URLSessionTask?

    // MARK: - Init
    init(url: URL, method: HTTPMethod, parameters: [String: Any], headers: [String: String]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers

        self.session = URLSession(configuration: .default)
    }

    // MARK: - Functions
    func cancel() {
        task?.cancel()
    }

    func responseData(completion: @escaping (Result<Data, WebserviceError>) -> Void) {
        task = session.dataTask(with: url) { data, response, error in
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
