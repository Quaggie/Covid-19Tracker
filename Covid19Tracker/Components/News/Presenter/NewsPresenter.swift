//
//  NewsPresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import CovidCharts

protocol NewsPresenterDelegate {
    var news: [News] { get }
    func fetch(completion: @escaping (Result<[News], ConnectionError>) -> Void)
}

final class NewsPresenter: NewsPresenterDelegate {
    private let newsFetcher: NewsFetcher
    private(set) var news: [News] = []

    init(newsFetcher: NewsFetcher) {
        self.newsFetcher = newsFetcher
    }

    func fetch(completion: @escaping (Result<[News], ConnectionError>) -> Void) {
        newsFetcher.fetch { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.news = articles.map(News.from(model:))
                completion(.success(self.news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
