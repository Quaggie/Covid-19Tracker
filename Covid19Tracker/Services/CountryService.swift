//
//  CountryService.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

protocol CountryServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<Country, WebserviceError>) -> Void)
}

final class CountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetch(country: String, completion: @escaping (Result<Country, WebserviceError>) -> Void) {
        let urlString = "/v2/countries/\(country)"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(Country.self, from: data)
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
