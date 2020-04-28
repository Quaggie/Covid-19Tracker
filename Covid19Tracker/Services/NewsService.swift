//
//  NewsService.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

protocol NewsServiceProtocol {
    func fetch(completion: @escaping (Result<[News], WebserviceError>) -> Void)
}

final class NewsService: NewsServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager(source: .google)) {
        self.networkManager = networkManager
    }

    func fetch(completion: @escaping (Result<[News], WebserviceError>) -> Void) {
        let urlString = "/top-headlines?category=health&q=covid"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                    let decodedObject = try JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(.success(decodedObject.articles))
                 } catch {
                    completion(.failure(WebserviceError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
