//
//  WorldOverviewService.swift
//  Data
//
//  Created by Jonathan Bijos on 09/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

final class WorldOverviewService: WorldOverviewUseCase {
    private let worldService: WorldServiceProtocol
    private let historicalInfoService: HistoricalInfoServiceProtocol

    public init(worldService: WorldServiceProtocol, historicalInfoService: HistoricalInfoServiceProtocol) {
        self.worldService = worldService
        self.historicalInfoService = historicalInfoService
    }

    func fetch(completion: @escaping (Result<WorldOverview, ConnectionError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var timelineModel: TimelineModel?
        var historicalTimeline: [HistoricalTimelineDayInfo]?
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
                historicalTimeline = HistoricalTimelineDayInfo.last7Days(from: model)
            case .failure(let error):
                connectionError = error
            }
        }


        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let result = self.transformResult(timeline: timelineModel, historicalTimeline: historicalTimeline, error: connectionError)
            completion(result)
        }
    }

    private func transformResult(
        timeline: TimelineModel?,
        historicalTimeline: [HistoricalTimelineDayInfo]?,
        error: ConnectionError?
    ) -> Result<WorldOverview, ConnectionError> {
        if let timeline = timeline, let historicalTimeline = historicalTimeline {
            let model = WorldOverview(timeline: timeline, historicalTimelineWeekInfo: historicalTimeline)
            return .success(model)
        }
        if let error = error {
            return .failure(error)
        }

        return .failure(.unexpected)
    }
}
