//
//  HistoricalTimelineDayInfo.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation
import Data

struct HistoricalTimelineDayInfo {
    let day: String
    let active: Int
    let recovered: Int
    let deaths: Int

    static func last7Days(from model: HistoricalCountryInfoModel.Timeline) -> [HistoricalTimelineDayInfo] {
        let now = Date()
        let calendar = Calendar.current
        let last7Days: [Date] = Array(1...7).map { calendar.date(byAdding: .day, value: -$0, to: now)! }.reversed()
        return last7Days.compactMap { from(model: model, date: $0) }
    }

    private static func from(model: HistoricalCountryInfoModel.Timeline, date: Date) -> HistoricalTimelineDayInfo? {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"

        var active: Int?
        var recovered: Int?
        var deaths: Int?

        if let caseObj = model.cases.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
            active = caseObj.value
        }

        if let recoveredObj = model.recovered.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
            recovered = recoveredObj.value
        }

        if let deathObj = model.deaths.first(where: { (key: String, _) -> Bool in key == formatter.string(from: date) }) {
            deaths = deathObj.value
        }

        if let active = active, let recovered = recovered, let deaths = deaths {
            let brDateformatter = DateFormatter()
            brDateformatter.dateFormat = "dd/MM"

            return HistoricalTimelineDayInfo(
                day: brDateformatter.string(from: date),
                active: active,
                recovered: recovered,
                deaths: deaths
            )
        }
        return nil
    }
}
