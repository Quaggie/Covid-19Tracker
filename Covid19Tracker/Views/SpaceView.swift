//
//  SpaceView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

class SpaceView: UIView {
    private let space: CGFloat

    override var intrinsicContentSize: CGSize {
        return CGSize(width: space, height: space)
    }

    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
