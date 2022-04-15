//
//  NewsPresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

protocol NewsPresenterDelegate {
    func fetch(completion: @escaping (Result<[News], ConnectionError>) -> Void)
}

final class NewsPresenter: NewsPresenterDelegate {
    private let newsFetcher: NewsFetcher

    init(newsFetcher: NewsFetcher) {
        self.newsFetcher = newsFetcher
    }

    func fetch(completion: @escaping (Result<[News], ConnectionError>) -> Void) {
        newsFetcher.fetch { result in
            switch result {
            case .success(let articles):
                let news = articles.map(News.from(model:))
                completion(.success(news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
