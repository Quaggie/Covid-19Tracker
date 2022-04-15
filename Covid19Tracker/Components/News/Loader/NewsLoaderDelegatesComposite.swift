//
//  NewsLoaderDelegatesComposite.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import Foundation

final class NewsLoaderDelegatesComposite: DelegatesComposite {
    var delegates = NSHashTable<AnyObject>.weakObjects()

    func addDelegate(_ delegate: NewsLoader) {
        delegates.add(delegate)
    }

    private var allDelegates: [NewsLoader] {
        delegates.allObjects as! [NewsLoader]
    }
}

extension NewsLoaderDelegatesComposite: NewsLoader {
    func load(news: [News]) {
        allDelegates.forEach { $0.load(news: news) }
    }
}
