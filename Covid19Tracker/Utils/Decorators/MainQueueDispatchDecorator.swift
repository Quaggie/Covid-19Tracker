//
//  MainQueueDispatchDecorator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import CovidCharts

final class MainQueueDispatchDecorator<T> {
    var instance: T

    init(instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainQueueDispatchDecorator: WorldFetcher where T: WorldFetcher {
    func fetchCases(completion: @escaping (Result<TimelineModel, ConnectionError>) -> Void) {
        instance.fetchCases { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: CountryFetcher where T: CountryFetcher {
    func fetch(country: String, completion: @escaping (Result<CountryModel, ConnectionError>) -> Void) {
        instance.fetch(country: country) { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }

    func fetchAll(sort: Bool, completion: @escaping (Result<[CountryModel], ConnectionError>) -> Void) {
        instance.fetchAll(sort: sort) { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: HistoricalInfoFetcher where T: HistoricalInfoFetcher {
    func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfoModel, ConnectionError>) -> Void) {
        instance.fetch(country: country) { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }

    func fetchAll(completion: @escaping (Result<HistoricalCountryInfoModel.Timeline, ConnectionError>) -> Void) {
        instance.fetchAll { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: NewsFetcher where T: NewsFetcher {
    func fetch(completion: @escaping (Result<[NewsModel.Article], ConnectionError>) -> Void) {
        instance.fetch { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}
