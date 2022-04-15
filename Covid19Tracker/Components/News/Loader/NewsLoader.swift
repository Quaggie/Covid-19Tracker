//
//  NewsLoader.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

protocol NewsLoader: AnyObject {
    func load(news: [News])
}
