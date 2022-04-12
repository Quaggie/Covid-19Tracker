//
//  News.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 04/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import CovidCharts

struct News: Equatable {
    let source: String
    let title: String
    let url: URL
    let urlToImage: URL?
    let publishedAt: String

    func color(forIndex index: Int) -> UIColor {
        if index == 0 {
            return Color.purpleLight
        } else if index % 3 == 0 {
            return Color.yellowDark
        } else if index % 2 == 0 {
            return Color.blueLight
        } else if index % 1 == 0 {
            return Color.greenDark
        } else {
            return Color.purpleLight
        }
    }

    static func from(model: NewsModel.Article) -> News {
        News(
            source: model.source.name,
            title: model.title,
            url: model.url,
            urlToImage: model.urlToImage,
            publishedAt: model.publishedAt
        )
    }
}
