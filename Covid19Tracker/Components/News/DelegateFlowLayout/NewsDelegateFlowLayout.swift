//
//  NewsDelegateFlowLayout.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

import UIKit
import SafariServices

final class NewsDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    private var news: [News] = []
    var viewControllerPresenter: ViewControllerPresenter?

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = news[indexPath.item]
        let controller = SFSafariViewController(url: model.url)
        viewControllerPresenter?.show(controller, sender: self)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        return NewsCell.size(width: width)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}

extension NewsDelegateFlowLayout: NewsLoader {
    func load(news: [News]) {
        self.news = news
    }
}
