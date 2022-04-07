//
//  CountryService.swift
//  Data
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public protocol CountryServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<CountryModel, NetworkError>) -> Void)
    func fetchAll(sort: Bool, completion: @escaping (Result<[CountryModel], NetworkError>) -> Void)
}

public final class CountryService: CountryServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetch(country: String, completion: @escaping (Result<CountryModel, NetworkError>) -> Void) {
        guard let encodedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.unparseable))
            return
        }
        let urlString = "/countries/\(encodedCountry)"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(CountryModel.self, from: data)
                    completion(.success(decodedObject))
                 } catch {
                    completion(.failure(NetworkError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func fetchAll(sort: Bool, completion: @escaping (Result<[CountryModel], NetworkError>) -> Void) {
        var urlString = "/countries"
        if sort {
            urlString += "?sort=cases"
        }

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode([CountryModel].self, from: data)
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
