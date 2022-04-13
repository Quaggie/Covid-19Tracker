//
//  HistoricalTimelineDayInfoModel.swift
//  CovidCharts
//
//  Created by Jonathan Bijos on 12/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

public struct HistoricalTimelineDayInfoModel {
    public let day: String
    public let active: Int
    public let recovered: Int
    public let deaths: Int

    private static func formatDayFor(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }

    private static func formatTimelineFor(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter.string(from: date)
    }

    private static func timelineValueFor(date: Date, in model: [String: Int]) -> Int? {
        if let obj = model.first(where: { (key: String, _) -> Bool in key == formatTimelineFor(date: date) }) {
            return obj.value
        }
        return nil
    }

    static func last7Days(from model: HistoricalCountryInfoModel.Timeline) -> [HistoricalTimelineDayInfoModel] {
        let now = Date()
        let calendar = Calendar.current
        let last7Days: [Date] = Array(1...7).map { calendar.date(byAdding: .day, value: -$0, to: now)! }.reversed()
        return last7Days.compactMap { from(model: model, date: $0) }
    }

    private static func from(model: HistoricalCountryInfoModel.Timeline, date: Date) -> HistoricalTimelineDayInfoModel? {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"

        let active = timelineValueFor(date: date, in: model.cases)
        let recovered = timelineValueFor(date: date, in: model.recovered)
        let deaths = timelineValueFor(date: date, in: model.deaths)

        if let active = active, let recovered = recovered, let deaths = deaths {
            return HistoricalTimelineDayInfoModel(
                day: formatDayFor(date: date),
                active: active,
                recovered: recovered,
                deaths: deaths
            )
        }
        return nil
    }
}
