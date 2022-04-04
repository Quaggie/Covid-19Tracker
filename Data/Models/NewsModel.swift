//
//  NewsModel.swift
//  Data
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

public struct NewsModel: Codable, Equatable {
    public struct Article: Codable, Equatable {
        public struct Source: Codable, Equatable {
            public let name: String
        }

        public let source: Source
        public let title: String
        public let url: String
        public let urlToImage: String
        public let publishedAt: String
    }
    public let status: String
    public let totalResults: Int
    public let articles: [Article]
}
