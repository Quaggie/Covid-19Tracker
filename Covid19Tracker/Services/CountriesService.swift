//
//  CountriesService.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

protocol CountriesServiceProtocol {
    func fetchCases(completion: @escaping (Result<[Country], WebserviceError>) -> Void)
}

final class CountriesService: CountriesServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchCases(completion: @escaping (Result<[Country], WebserviceError>) -> Void) {
        let urlString = "/v2/countries?sort=cases"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode([Country].self, from: data)
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
