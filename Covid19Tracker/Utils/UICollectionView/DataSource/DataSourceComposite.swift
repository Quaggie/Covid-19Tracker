//
//  DataSourceComposite.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class DataSourceComposite: NSObject, UICollectionViewDataSource, CellRegistrationable {
    private let dataSources: [DataSource]

    init(dataSources: [DataSource]) {
        self.dataSources = dataSources
    }

    func registerCells(on collectionView: UICollectionView) {
        for dataSource in dataSources {
            dataSource.registerCells(on: collectionView)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSources.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource(forSection: section, in: collectionView).collectionView(collectionView, numberOfItemsInSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dataSource(forSection: indexPath.section, in: collectionView).collectionView(collectionView, cellForItemAt: indexPath)
    }

    private func dataSource(forSection section: Int, in collectionView: UICollectionView) -> UICollectionViewDataSource {
        dataSources[section]
    }
}
