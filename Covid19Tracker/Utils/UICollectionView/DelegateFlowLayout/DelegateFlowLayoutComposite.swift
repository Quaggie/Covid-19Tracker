//
//  DelegateFlowLayoutComposite.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 30/03/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit

final class DelegateFlowLayoutComposite: NSObject, UICollectionViewDelegateFlowLayout {
    let delegateFlowLayouts: [UICollectionViewDelegateFlowLayout]

    init(delegateFlowLayouts: [UICollectionViewDelegateFlowLayout]) {
        self.delegateFlowLayouts = delegateFlowLayouts
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        delegateFlowLayout(forSection: indexPath.section)
            .collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        delegateFlowLayout(forSection: section)
            .collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        delegateFlowLayout(forSection: section)
            .collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
    }

    private func delegateFlowLayout(forSection section: Int) -> UICollectionViewDelegateFlowLayout {
        delegateFlowLayouts[section]
    }
}
