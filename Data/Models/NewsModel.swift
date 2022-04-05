//
//  NewsModel.swift
//  Data
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

public struct NewsModel: Codable, Equatable {
    public struct Article: Codable, Equatable {
        public struct Source: Codable, Equatable {
            public let name: String
        }

        public let source: Source
        public let title: String
        public let url: URL
        public let urlToImage: URL?
        public let publishedAt: String
    }
    public let status: String
    public let totalResults: Int
    public let articles: [Article]
}
