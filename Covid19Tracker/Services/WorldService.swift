//
//  WorldService.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

protocol WorldServiceProtocol {
    func fetchCases(completion: @escaping (Result<Timeline, WebserviceError>) -> Void)
}

final class WorldService: WorldServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchCases(completion: @escaping (Result<Timeline, WebserviceError>) -> Void) {
        let urlString = "/v2/all"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(Timeline.self, from: data)
                    completion(.success(decodedObject))
                 } catch {
                    completion(.failure(WebserviceError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
