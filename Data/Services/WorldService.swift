//
//  WorldService.swift
//  Data
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public protocol WorldServiceProtocol {
    func fetchCases(completion: @escaping (Result<TimelineModel, NetworkError>) -> Void)
}

public final class WorldService: WorldServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetchCases(completion: @escaping (Result<TimelineModel, NetworkError>) -> Void) {
        let urlString = "/all"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(TimelineModel.self, from: data)
                    completion(.success(decodedObject))
                 } catch {
                    completion(.failure(NetworkError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
