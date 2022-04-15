//
//  WorldOverviewService.swift
//  Data
//
//  Created by Jonathan Bijos on 09/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

public protocol WorldOverviewFetcher {
    func fetch(completion: @escaping (Result<WorldOverviewModel, ConnectionError>) -> Void)
}

public final class WorldOverviewService: WorldOverviewFetcher {
    private let worldService: WorldFetcher
    private let historicalInfoService: HistoricalInfoFetcher

    public init(worldService: WorldFetcher, historicalInfoService: HistoricalInfoFetcher) {
        self.worldService = worldService
        self.historicalInfoService = historicalInfoService
    }

    public func fetch(completion: @escaping (Result<WorldOverviewModel, ConnectionError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var timelineModel: TimelineModel?
        var historicalTimeline: [HistoricalTimelineDayInfoModel]?
        var connectionError: ConnectionError?

        dispatchGroup.enter()
        worldService.fetchCases { result in
            dispatchGroup.leave()

            switch result {
            case .success(let model):
                timelineModel = model
            case .failure(let error):
                connectionError = error
            }
        }

        dispatchGroup.enter()
        self.historicalInfoService.fetchAll { result in
            dispatchGroup.leave()

            switch result {
            case .success(let model):
                historicalTimeline = HistoricalTimelineDayInfoModel.last7Days(from: model)
            case .failure(let error):
                connectionError = error
            }
        }

        dispatchGroup.notify(queue: .global(qos: .default)) { [weak self] in
            guard let self = self else { return }
            let result = self.transformResult(timeline: timelineModel, historicalTimeline: historicalTimeline, error: connectionError)
            completion(result)
        }
    }

    private func transformResult(
        timeline: TimelineModel?,
        historicalTimeline: [HistoricalTimelineDayInfoModel]?,
        error: ConnectionError?
    ) -> Result<WorldOverviewModel, ConnectionError> {
        if let timeline = timeline, let historicalTimeline = historicalTimeline {
            let model = WorldOverviewModel(timeline: timeline, historicalTimelineWeekInfo: historicalTimeline)
            return .success(model)
        }
        if let error = error {
            return .failure(error)
        }

        return .failure(.unexpected)
    }
}
