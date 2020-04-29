//
//  News.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

struct News: Codable {
    struct Source: Codable {
        let id: String
        let name: String
    }

    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

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
}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}
