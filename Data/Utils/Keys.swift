//
//  Keys.swift
//  Data
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

enum Keys {
    static var newsApi: String {
        guard let path = Bundle(for: NewsService.self).path(forResource: "Keys", ofType: "plist") else {
            fatalError("Could not find Keys.plist file")
        }
        guard let json = NSDictionary(contentsOfFile: path) else {
            fatalError("Could not transform filepath \(path) into json")
        }
        guard let value = json["NEWS_API_KEY"] as? String else {
            fatalError("Could not find newsApi key in Keys.plist")
        }
        return value
    }
}
