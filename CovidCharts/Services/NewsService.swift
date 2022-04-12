//
//  NewsService.swift
//  Data
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public protocol NewsServiceProtocol {
    func fetch(completion: @escaping (Result<[NewsModel.Article], ConnectionError>) -> Void)
}

public final class NewsService: NewsServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager(source: .google)) {
        self.networkManager = networkManager
    }

    public func fetch(completion: @escaping (Result<[NewsModel.Article], ConnectionError>) -> Void) {
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
                    let decodedObject = try JSONDecoder().decode(NewsModel.self, from: data)
                    completion(.success(decodedObject.articles))
                 } catch {
                    completion(.failure(.unparseable))
                 }
            case .failure(let error):
                completion(.failure(ConnectionError.from(networkError: error)))
            }
        }
    }
}
