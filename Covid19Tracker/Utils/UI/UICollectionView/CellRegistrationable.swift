//
//  CellRegistrationable.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

protocol CellRegistrationable: AnyObject {
    func registerCells(on collectionView: UICollectionView)
}
