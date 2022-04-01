//
//  CountryService.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

protocol CountryServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<Country, WebserviceError>) -> Void)
    func fetchAll(sort: Bool, completion: @escaping (Result<[Country], WebserviceError>) -> Void)
}

final class CountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetch(country: String, completion: @escaping (Result<Country, WebserviceError>) -> Void) {
        guard let encodedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.unparseable))
            return
        }
        let urlString = "/countries/\(encodedCountry)"

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

    func fetchAll(sort: Bool, completion: @escaping (Result<[Country], WebserviceError>) -> Void) {
        var urlString = "/countries"
        if sort {
            urlString += "?sort=cases"
        }

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

extension MainQueueDispatchDecorator: CountryServiceProtocol where T: CountryServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<Country, WebserviceError>) -> Void) {
        instance.fetch(country: country) { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }

    func fetchAll(sort: Bool, completion: @escaping (Result<[Country], WebserviceError>) -> Void) {
        instance.fetchAll(sort: sort) { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}
