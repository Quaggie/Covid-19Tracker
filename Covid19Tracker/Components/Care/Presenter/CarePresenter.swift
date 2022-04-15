//
//  CarePresenter.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 15/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

protocol CarePresenterDelegate {
    var selectedIndex: Int { get }
}

final class CarePresenter: CarePresenterDelegate {
    private(set) var selectedIndex: Int = 0
}

extension CarePresenter: PageSelectorDelegate {
    func pageSelectorDidChange(index: Int) {
        selectedIndex = index
    }
}
