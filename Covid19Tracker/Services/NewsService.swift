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
        let q = "covid"
        let category = "health"
        let page = 1
        let pageSize = 10
        let country = "br"
        let urlString = "/top-headlines?category=\(category)&q=\(q)&page=\(page)&pageSize=\(pageSize)&country=\(country)"

        let headers: [String: String] = ["x-api-key" : Keys.newsApi]
        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: headers) { result in
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

extension MainQueueDispatchDecorator: NewsServiceProtocol where T: NewsServiceProtocol {
    func fetch(completion: @escaping (Result<[News], WebserviceError>) -> Void) {
        instance.fetch { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}
