//
//  HistoricalInfoService.swift
//  Data
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public protocol HistoricalInfoServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfoModel, ConnectionError>) -> Void)
    func fetchAll(completion: @escaping (Result<HistoricalCountryInfoModel.Timeline, ConnectionError>) -> Void)
}

public final class HistoricalInfoService: HistoricalInfoServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfoModel, ConnectionError>) -> Void) {
        guard let encodedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.unparseable))
            return
        }
        let urlString = "/historical/\(encodedCountry)?lastdays=7"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(HistoricalCountryInfoModel.self, from: data)
                     completion(.success(decodedObject))
                 } catch {
                    completion(.failure(.unparseable))
                 }
            case .failure(let error):
                completion(.failure(ConnectionError.from(networkError: error)))
            }
        }
    }

    public func fetchAll(completion: @escaping (Result<HistoricalCountryInfoModel.Timeline, ConnectionError>) -> Void) {
        let urlString = "/historical/all?lastdays=7"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                     let decodedObject = try JSONDecoder().decode(HistoricalCountryInfoModel.Timeline.self, from: data)
                     completion(.success(decodedObject))
                 } catch {
                    completion(.failure(.unparseable))
                 }
            case .failure(let error):
                completion(.failure(ConnectionError.from(networkError: error)))
            }
        }
    }
}
