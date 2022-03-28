//
//  NetworkManager.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import UIKit

protocol NetworkManagerProtocol {
    func fetch(
        urlString: String,
        method: HTTPMethod,
        parameters: [String: Any],
        headers: [String: String],
        completion: @escaping (Result<Data, WebserviceError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Enum
    enum Source {
        case covid
        case google
    }

    // MARK: - Properties
    private let source: Source
    private var requests: [WebserviceRequest] = []
    private var baseUrl: String {
        switch source {
        case .covid:
            return "https://disease.sh/v3/covid-19"
        case .google:
            return "https://newsapi.org/v2"
        }
    }

    // MARK: - Init
    init(source: Source = .covid) {
        self.source = source
    }

    // MARK: - Protocol
    func fetch(urlString: String,
               method: HTTPMethod,
               parameters: [String: Any],
               headers: [String: String],
               completion: @escaping (Result<Data, WebserviceError>) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(urlString)") else {
            completion(.failure(WebserviceError.malformedURL))
            return
        }
        let request = DefaultDataRequest(url: url, method: method, parameters: parameters, headers: headers, cache: source == .google)

        request.responseData { [weak self] result in
            guard let self = self else { return }
            self.requests.removeAll { $0.task?.hashValue == request.task?.hashValue }

            DispatchQueue.main.async {
                completion(result)
            }
        }
        self.requests.append(request)
    }

    // MARK: - Deinit
    deinit {
      print("DEINIT NetworkManager")
      requests.forEach { $0.cancel() }
    }
}
