//
//  CareDataSource.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class CareDataSource: NSObject, UICollectionViewDataSource, CellRegistrationable {
    private let preventionModels: [CareModel]
    private let symptomModels: [CareModel]
    private var index: Int = 0

    init(preventionModels: [CareModel], symptomModels: [CareModel]) {
        self.preventionModels = preventionModels
        self.symptomModels = symptomModels
    }

    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CareCardCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        index == 0 ? preventionModels.count : symptomModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = index == 0 ? preventionModels[indexPath.item] : symptomModels[indexPath.item]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareCardCell
        cell.setup(model: model)
        return cell
    }
}

extension CareDataSource: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        self.index = index
    }
}
