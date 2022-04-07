//
//  MainQueueDispatchDecorator.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 29/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import Data

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

extension MainQueueDispatchDecorator: WorldServiceProtocol where T: WorldServiceProtocol {
    func fetchCases(completion: @escaping (Result<TimelineModel, ConnectionError>) -> Void) {
        instance.fetchCases { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: CountryServiceProtocol where T: CountryServiceProtocol {
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

extension MainQueueDispatchDecorator: HistoricalInfoServiceProtocol where T: HistoricalInfoServiceProtocol {
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

extension MainQueueDispatchDecorator: NewsServiceProtocol where T: NewsServiceProtocol {
    func fetch(completion: @escaping (Result<[NewsModel.Article], ConnectionError>) -> Void) {
        instance.fetch { [weak self] result in
            guard let self = self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
}
