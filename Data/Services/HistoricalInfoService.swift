//
//  HistoricalInfoService.swift
//  Data
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation
import Networking

public struct HistoricalCountryInfo: Codable {
    public let country: String
    public let timeline: [HistoricalTimelineDayInfo]
}

public struct HistoricalTimelineDayInfo: Codable {
    public let day: String
    public let active: Int
    public let recovered: Int
    public let deaths: Int
}


public protocol HistoricalInfoServiceProtocol {
    func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfo, WebserviceError>) -> Void)
    func fetchAll(completion: @escaping (Result<[HistoricalTimelineDayInfo], WebserviceError>) -> Void)
}

public final class HistoricalInfoService: HistoricalInfoServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetch(country: String, completion: @escaping (Result<HistoricalCountryInfo, WebserviceError>) -> Void) {
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
                    let list = self.historicalTimelineDayInfo(from: decodedObject.timeline)
                    let countryInfo = HistoricalCountryInfo(country: decodedObject.country, timeline: list)

                    completion(.success(countryInfo))
                 } catch {
                    completion(.failure(WebserviceError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func fetchAll(completion: @escaping (Result<[HistoricalTimelineDayInfo], WebserviceError>) -> Void) {
        let urlString = "/historical/all?lastdays=7"

        networkManager.fetch(urlString: urlString, method: .get, parameters: [:], headers: [:]) { result in
            switch result {
            case .success(let data):
                 do {
                     let decodedObject = try JSONDecoder().decode(HistoricalCountryInfoModel.Timeline.self, from: data)
                    let list = self.historicalTimelineDayInfo(from: decodedObject)

                    completion(.success(list))
                 } catch {
                    completion(.failure(WebserviceError.unparseable))
                 }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func historicalTimelineDayInfo(from response: HistoricalCountryInfoModel.Timeline) -> [HistoricalTimelineDayInfo] {
        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"

        let last7Days: [Date] = [
            calendar.date(byAdding: .day, value: -7, to: now)!,
            calendar.date(byAdding: .day, value: -6, to: now)!,
            calendar.date(byAdding: .day, value: -5, to: now)!,
            calendar.date(byAdding: .day, value: -4, to: now)!,
            calendar.date(byAdding: .day, value: -3, to: now)!,
            calendar.date(byAdding: .day, value: -2, to: now)!,
            calendar.date(byAdding: .day, value: -1, to: now)!,
        ]

        var historicalTimelineDayInfoList: [HistoricalTimelineDayInfo] = []

        last7Days.forEach { date in
            var active: Int?
            var recovered: Int?
            var deaths: Int?

            if let caseObj = response.cases.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
                active = caseObj.value
            }

            if let recoveredObj = response.recovered.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
                recovered = recoveredObj.value
            }

            if let deathObj = response.deaths.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
                deaths = deathObj.value
            }

            if let active = active, let recovered = recovered, let deaths = deaths {
                let brDateformatter = DateFormatter()
                brDateformatter.dateFormat = "dd/MM"

                let historicalTimelineDayInfo = HistoricalTimelineDayInfo(day: brDateformatter.string(from: date),
                                                                          active: active,
                                                                          recovered: recovered,
                                                                          deaths: deaths)
                historicalTimelineDayInfoList.append(historicalTimelineDayInfo)
            }
        }

        return historicalTimelineDayInfoList
    }
}
