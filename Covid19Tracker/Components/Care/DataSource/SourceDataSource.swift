//
//  SourceDataSource.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import SafariServices

final class SourceDataSource: NSObject, UICollectionViewDataSource, CellRegistrationable {
    private let source = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019")!
    var viewControllerPresenter: ViewControllerPresenter?

    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(CareSourceCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CareSourceCell
        cell.onTapLink = { [weak self] in
            let url = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019")!
            let controller = SFSafariViewController(url: url)
            self?.viewControllerPresenter?.show(controller, sender: self)
        }
        return cell
    }
}
