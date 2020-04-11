//
//  NetworkManager.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//


import UIKit

final class NetworkManager: NetworkManagerProtocol {
    private var requests: [WebserviceRequest] = []
    private let baseUrl: String = "https://corona.lmao.ninja"

    func fetch(urlString: String,
               method: HTTPMethod,
               parameters: [String: Any],
               headers: [String: String],
               completion: @escaping (Result<Data, WebserviceError>) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(urlString)") else {
            completion(.failure(WebserviceError.malformedURL))
            return
        }
        let request = DefaultDataRequest(url: url, method: method, parameters: parameters, headers: headers)
        request.responseData { [weak self] result in
            guard let self = self else { return }
            self.requests.removeAll { $0.task?.hashValue == request.task?.hashValue }

            completion(result)
        }
        self.requests.append(request)
    }

    deinit {
      print("DEINIT NetworkManager")
      requests.forEach { $0.cancel() }
    }
}
