//
//  Array+PreviousNext.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 13/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func next(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 <= count {
            return index + 1 == count ? nil : self[index + 1]
        }

        return nil
    }

    func previous(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index >= 0 {
            return index == 0 ? nil : self[index - 1]
        }
        return nil
    }
}
