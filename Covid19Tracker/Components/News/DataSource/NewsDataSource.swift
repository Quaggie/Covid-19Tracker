//
//  NewsDataSource.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class NewsDataSource: NSObject, DataSource {
    private var news: [News] = []

    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(NewsCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = news[indexPath.item]

        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NewsCell
        cell.setup(model: model, index: indexPath.item)
        return cell
    }
}

extension NewsDataSource: NewsLoader {
    func load(news: [News]) {
        self.news = news
    }
}
